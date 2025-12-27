import 'dart:developer' as developer;
import 'package:dio/dio.dart' show DioException;
import 'package:u/utilities.dart';

import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/widgets/fields/fields.dart';
import '../../../../../../core/widgets/image_files.dart';
import '../../../../../../core/widgets/profile_upload_and_show_image.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/services/websocket_service.dart';
import '../../../../../../data/data.dart';
import '../../../data/datasources/professional_chat_remote_datasource.dart';
import '../../../data/dto/conversation_dtos.dart';
import '../../../data/repositories/professional_chat_repository_impl.dart';
import '../../../domain/repositories/professional_chat_repository.dart';
import '../messages/conversation_messages_page.dart';

class CreateUpdateGroupPage extends StatefulWidget {
  const CreateUpdateGroupPage({super.key, this.model});

  final ConversationDto? model;

  @override
  State<CreateUpdateGroupPage> createState() => _CreateUpdateGroupPageState();
}

class _CreateUpdateGroupPageState extends State<CreateUpdateGroupPage> {
  String? _conversationId;
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  List<UserReadDto> _selectedMembers = [];
  final RxBool _isLoading = false.obs;
  MainFileReadDto? _avatar;
  bool _isUpLoadingFile = false;
  bool _isEditing = false;

  final ProfessionalChatRepository _repository = ProfessionalChatRepositoryImpl(
    webSocketService: WebSocketService(),
    remoteDataSource: Get.find<ProfessionalChatRemoteDataSource>(),
    memberDataSource: Get.find<MemberDatasource>(),
  );

  @override
  void initState() {
    _conversationId = widget.model?.id;
    _isEditing = widget.model != null && _conversationId != null;
    _titleCtrl.text = widget.model?.title ?? '';
    _descriptionCtrl.text = widget.model?.description ?? '';
    _avatar = widget.model?.avatarUrl != null ? MainFileReadDto(url: widget.model?.avatarUrl) : null;
    super.initState();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _isLoading.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      appBar: AppBar(
        title: Text(_isEditing ? s.editGroup : s.newGroup),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
        child: Obx(
          () => UElevatedButton(
            isLoading: _isLoading.value,
            title: _isEditing ? s.save : s.submit,
            onTap: _callApi,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 18,
            children: [
              Column(
                spacing: 10,
                children: [
                  WProfileUploadAndShowImage(
                    file: _avatar,
                    onUploaded: (final file) => _avatar = file,
                    onRemove: (final file) => _avatar = null,
                    uploadStatus: (final value) => _isUpLoadingFile = value,
                  ).alignAtCenter(),
                  Text(s.uploadPhoto, textAlign: TextAlign.center).bodyMedium(color: context.theme.hintColor),
                ],
              ),
              WTextField(
                controller: _titleCtrl,
                labelText: s.groupTitle,
                required: true,
                showRequired: false,
                maxLength: 100,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              WTextField(
                controller: _descriptionCtrl,
                labelText: s.description,
                maxLines: 3,
                multiLine: true,
                showCounter: true,
                maxLength: 500,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              if (_isEditing == false)
                WMembersPickerFormField(
                  labelText: s.members,
                  required: true,
                  selectedMembers: _selectedMembers,
                  onConfirm: (final list) {
                    _selectedMembers = list;
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _callApi() {
    validateForm(
      key: _formKey,
      action: () {
        WImageFiles.checkFileUploading(
          isUploadingFile: _isUpLoadingFile,
          action: () async {
            _isLoading.value = true;
            try {
              if (_isEditing == false) {
                await _createGroup();
              } else {
                await _updateGroup();
              }
            } catch (e, s) {
              developer.log("_createUpdateGroup error => e: $e\ns: $s");
            } finally {
              if (!_isLoading.subject.isClosed) {
                _isLoading.value = false;
              }
            }
          },
        );
      },
    );
  }

  Future<void> _createGroup() async {
    try {
      final conversation = await _repository.createGroup(
        avatarUrl: _avatar?.url,
        title: _titleCtrl.text.trim(),
        memberIds: _selectedMembers
            .map((final member) {
              if (member.id.trim().numericOnly().isEmpty) return null;
              return member.id.numericOnly().toInt();
            })
            .whereType<int>()
            .toList(),
        description: _descriptionCtrl.text.trim().isEmpty ? null : _descriptionCtrl.text.trim(),
      );
      UNavigator.off(ConversationMessagesPage(conversation: conversation));
    } on DioException {
      return;
    }
  }

  Future<void> _updateGroup() async {
    if (_conversationId == null) return;
    try {
      await _repository.updateGroup(
        _conversationId!,
        avatar: _avatar,
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim().isEmpty ? null : _descriptionCtrl.text.trim(),
      );
      UNavigator.back();
    } on DioException {
      return;
    }
  }
}
