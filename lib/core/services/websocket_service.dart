import 'dart:developer' as developer;
import 'package:u/utilities.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:math' as math;

import '../../app_config.dart';
import '../core.dart';
import '../functions/init_app_functions.dart';
import '../navigator/navigator.dart';
import '../utils/enums/enums.dart';
import 'secure_storage_service.dart';
import '../../data/data.dart';

class WebSocketService with WidgetsBindingObserver {
  static final WebSocketService _instance = WebSocketService._internal();

  factory WebSocketService() => _instance;

  WebSocketService._internal();

  //-----------------------------------------------------
  // App lifecycle pause/resume
  //-----------------------------------------------------

  void startLifecycleListener() {
    WidgetsBinding.instance.addObserver(this);
  }

  void stopLifecycleListener() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    developer.log('📱 AppLifecycleState changed: $state');

    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.detached:
        _onAppPaused();
        break;
    }
  }

  void _onAppPaused() {
    if (isConnected.value) {
      developer.log('⏸️ App paused → disconnecting WebSocket');
      disconnect();
    }
  }

  void _onAppResumed() {
    if (!isConnected.value && !_isReconnecting) {
      developer.log('▶️ App resumed → reconnecting WebSocket');
      connect();
    }
  }

  //-----------------------------------------------------
  //-----------------------------------------------------
  //-----------------------------------------------------

  WebSocketChannel? _channel;
  StreamSubscription? _socketSubscription;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _core = Get.find<Core>();

  Uri? _url;
  RxBool isConnected = false.obs;
  bool _isReconnecting = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 1000000;
  final List<Map<String, dynamic>> _messageQueue = [];

  // Callbacks
  Function(Map<String, dynamic> message)? onMessage;
  VoidCallback? onReconnect;
  VoidCallback? onConnectionLost;

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  Future<void> connect() async {
    if (isConnected.value == false) {
      _url = await _getUrl();
      if (_url == null) return;
      _initializeConnection();
    }
  }

  Future<Uri?> _getUrl() async {
    final token = await SecureStorageService.getChatWebsocketToken();
    if (token == null) return null;
    final uri = Uri.parse('${AppConfig.instance.wsBaseUrl}/ws/core/stream?token=$token');
    return uri;
  }

  void _initializeConnection() {
    _disposeSocket();

    if (_url == null) return;

    try {
      _channel = WebSocketChannel.connect(_url!);
      isConnected.value = false;

      _socketSubscription = _channel!.stream.listen(
        (final event) {
          if (!isConnected.value) {
            isConnected.value = true;
            _reconnectAttempts = 0;
            developer.log('✅ (Core WebSocket) connected');
            _flushMessageQueue();
            onReconnect?.call();
          }

          try {
            final Map<String, dynamic> jsonData = jsonDecode(event);
            developer.log('📩 (Core WebSocket) New message: $jsonData');
            _messageController.add(jsonData);
            onMessage?.call(jsonData);

            // global actions
            _pingPong(jsonData);
            _setUnreadMessagesCount(jsonData);
            _changeCurrentWorkspace(jsonData);
            _showSnackBar(jsonData);
          } catch (e, s) {
            developer.log('❌ Error parsing WebSocket message: e: $e \n s: $s');
          }
        },
        onError: (final error) {
          developer.log('❌ (Core WebSocket) error: $error');
          _handleDisconnection();
        },
        onDone: () {
          developer.log('❌❌ (Core WebSocket) closed');
          _handleDisconnection();
        },
        cancelOnError: true,
      );
    } catch (e, s) {
      developer.log('❌❌❌ (Core WebSocket) catch error: \ne:$e\ns:$s');
      _handleDisconnection();
    }
  }

  void send(final String command, final Map<String, dynamic> data) {
    final message = {
      'command': command,
      'data': data,
    };

    if (isConnected.value && _channel != null) {
      _channel!.sink.add(jsonEncode(message));
      developer.log('📤 Message sent: $message');
    } else {
      _messageQueue.add(message);
      developer.log('📤 Message queued: $command');
    }
  }

  void _flushMessageQueue() {
    while (_messageQueue.isNotEmpty) {
      if (_channel != null && isConnected.value) {
        final msg = _messageQueue.removeAt(0);
        _channel!.sink.add(jsonEncode(msg));
      }
    }
  }

  void _handleDisconnection() {
    isConnected(false);
    _disposeSocket();
    onConnectionLost?.call(); // ✅ callback
    if (!_isReconnecting) _attemptReconnect();
  }

  void _attemptReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      developer.log('❌ (Core WebSocket) Max reconnect attempts reached');
      return;
    }

    _isReconnecting = true;
    _reconnectAttempts++;

    // Exponential backoff: min(1000 * 2^attempt, 30000)
    final delay = math.min(
      20000,
      1000 * math.pow(2, _reconnectAttempts - 1).toInt(),
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(milliseconds: delay), () {
      developer.log('🔁 (Core WebSocket) Trying to reconnect ($_reconnectAttempts)...');
      _isReconnecting = false;
      connect();
    });
  }

  //--------------------------------------------------------------------------
  // Global Response Methods
  //--------------------------------------------------------------------------

  void _pingPong(final Map<String, dynamic> jsonData) {
    if (jsonData['status'] == 'ping') {
      _channel!.sink.add(jsonEncode({"status": 'pong'}));
    }
  }

  void _setUnreadMessagesCount(final Map<String, dynamic> jsonData) {
    if (jsonData['type'] == 'unread_messages_count') {
      _core.updateUnreadChatMessagesCount(jsonData['total_unread_count'] as int? ?? 0);
    }
  }

  void _changeCurrentWorkspace(final Map<String, dynamic> jsonData) {
    if (jsonData['data_type'] == 'change_current_workspace') {
      try {
        final WorkspaceReadDto model = WorkspaceReadDto.fromMap(jsonData['data']['current_workspace']);
        if (_core.currentWorkspace.value.id != model.id) {
          AppNavigator.snackbarGreen(title: '', subtitle: s.SwitchedBusiness.replaceAll('#', model.title ?? ''));
          initApp(currentWorkspaceChanged: true);
        }
      } catch (e) {
        developer.log("❌ (Core WebSocket) Error parsing [WorkspaceReadDto] model: e => $e");
      }
    }
  }

  void _showSnackBar(final Map<String, dynamic> jsonData) {
    final dataType = jsonData['type'] as String?;
    switch (dataType) {
      case "warning":
        final message = jsonData['message'] as String? ?? '';
        AppNavigator.snackbarOrange(title: s.warning, subtitle: message);
        break;
      case "info":
        final message = jsonData['message'] as String? ?? '';
        AppNavigator.snackbar(title: '', subtitle: message);
        break;
      case "success":
        final message = jsonData['message'] as String? ?? '';
        AppNavigator.snackbarGreen(title: s.done, subtitle: message);
        break;
      case "error":
        final message = jsonData['message'] as String? ?? '';
        AppNavigator.snackbarRed(title: s.error, subtitle: message);
        break;
    }
  }

  //-----------------------------------------------------------------------------
  //-----------------------------------------------------------------------------
  //-----------------------------------------------------------------------------

  void disconnect() {
    developer.log('🔌 (Core WebSocket) Closing WebSocket...');
    _reconnectTimer?.cancel();
    _isReconnecting = false;
    _reconnectAttempts = 0;
    _disposeSocket();
    isConnected(false);
  }

  void _disposeSocket() {
    _socketSubscription?.cancel();
    _socketSubscription = null;
    _channel?.sink.close(status.normalClosure);
    _channel = null;
  }

  //-------------------------------------------------------------------
  // Convenience methods for WebSocket commands
  //-------------------------------------------------------------------
  void getConversations() => send('get_conversations', {});

  void getMessages(final String conversationId, {final int page = 1, final int perPage = 50}) {
    send('get_messages', {
      'conversation_id': conversationId,
      'page': page,
      'per_page': perPage,
    });
  }

  void sendMessage({
    required final String conversationId,
    final String? text,
    required final MessageType type,
    final String? clientId,
    final List<String>? attachments,
    final int? duration,
  }) {
    send('send_message', {
      'conversation_id': conversationId,
      if (text != null) 'text': text,
      'type': type.name,
      if (clientId != null) 'client_id': clientId,
      if (attachments != null) 'attachments': attachments,
      if (duration != null) 'duration': duration,
    });
  }

  void replyToMessage({
    required final String conversationId,
    required final String replyToId,
    required final String text,
    final String? clientId,
  }) {
    send('reply_to_message', {
      'conversation_id': conversationId,
      'reply_to_id': replyToId,
      'text': text,
      'type': 'text',
      if (clientId != null) 'client_id': clientId,
    });
  }

  void editMessage(final String messageId, final String text) {
    send('edit_message', {
      'message_id': messageId,
      'text': text,
    });
  }

  void deleteMessage(final String messageId) {
    send('delete_message', {
      'message_id': messageId,
    });
  }

  void forwardMessages({
    required final List<String> messageIds,
    required final List<String> targetConversationIds,
    final bool withCaption = false,
    final String? caption,
  }) {
    send('forward_messages', {
      'message_ids': messageIds,
      'target_conversation_ids': targetConversationIds,
      'with_caption': withCaption,
      if (caption != null) 'caption': caption,
    });
  }

  void markAsRead(final String conversationId, final List<String> messageIds) {
    send('mark_as_read', {
      'conversation_id': conversationId,
      'message_ids': messageIds,
    });
  }

  void sendTyping(final String conversationId, final bool isTyping) {
    send('typing', {
      'conversation_id': conversationId,
      'is_typing': isTyping,
    });
  }

  void pinMessage(final String conversationId, final String messageId) {
    send('pin_message', {
      'conversation_id': conversationId,
      'message_id': messageId,
    });
  }

  void unpinMessage(final String conversationId, final String messageId) {
    send('unpin_message', {
      'conversation_id': conversationId,
      'message_id': messageId,
    });
  }

  void getPinnedMessages(final String conversationId) {
    send('get_pinned_messages', {
      'conversation_id': conversationId,
    });
  }

  void addReaction(final String messageId, final String emoji) {
    send('add_reaction', {
      'message_id': messageId,
      'emoji': emoji,
    });
  }

  void removeReaction(final String messageId, final String emoji) {
    send('remove_reaction', {
      'message_id': messageId,
      'emoji': emoji,
    });
  }

  void getMessageReplies(final String messageId) {
    send('get_message_replies', {
      'message_id': messageId,
    });
  }

  void sendAnonymousFeedback(
    final List<String> userIds,
    final String template,
    final int categoryId,
    final int subcategoryId,
    final String priority,
  ) {
    send('send_anonymous_feedback', {
      "category_id": categoryId,
      "subcategory_id": subcategoryId,
      "priority": priority,
      "selected_users": userIds.map((final e) => e.toInt()).toList(),
      "template": template,
    });
  }

  void getAnonymousFeedbacks({final int page = 1, final int perPage = 20}) {
    send('get_anonymous_feedbacks', {
      "page": page,
      "page_size": perPage,
    });
  }

  void addMember(final String conversationId, final String userId) {
    send('add_member', {
      'conversation_id': conversationId,
      'user_id': userId,
    });
  }

  void removeMember(final String conversationId, final String userId) {
    send('remove_member', {
      'conversation_id': conversationId,
      'user_id': userId,
    });
  }

  void leaveConversation(final String conversationId) {
    send('leave_conversation', {
      'conversation_id': conversationId,
    });
  }

  //-------------------------------------------------------------------
  //-------------------------------------------------------------------
  //-------------------------------------------------------------------
}
