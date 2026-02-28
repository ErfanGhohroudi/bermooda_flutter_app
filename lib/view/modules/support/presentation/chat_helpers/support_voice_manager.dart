import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:u/utilities.dart';
import 'package:vibration/vibration.dart';

import '../../domain/enums/message_type.dart';
import '../controllers/support_chat_controller.dart';

class SupportVoiceManager {
  SupportVoiceManager(this.controller);

  final SupportChatController controller;

  late final RecorderController recorderController;
  final RxBool isRecording = false.obs;
  final Rxn<String> recordedVoicePath = Rxn<String>(null);
  final Rxn<int?> recordedVoiceDuration = Rxn<int>(null);
  final RxString recordingVoiceElapsedSeconds = "00:00".obs;
  
  Timer? _recordingVoiceTimer;
  int _recordedVoiceDuration = 0;

  void onInit() {
    recorderController = RecorderController();
  }

  void onClose() {
    _recordingVoiceTimer?.cancel();
    recorderController.dispose();
  }

  Future<void> startRecording() async {
    final hadNotRequestedPermission = await Permission.microphone.status != PermissionStatus.granted;
    if (hadNotRequestedPermission) {
      await Permission.microphone.request();
      return;
    }

    Directory tempDir = Directory.systemTemp;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000);
    String path = '${tempDir.path}/recorded_audio_${timestamp}_$random.aac';

    if (await Vibration.hasVibrator() == true) {
      Vibration.vibrate(duration: 50);
    }

    await recorderController.record(
      path: path,
      recorderSettings: const RecorderSettings(
        androidEncoderSettings: AndroidEncoderSettings(
          androidEncoder: AndroidEncoder.opus,
        ),
        iosEncoderSettings: IosEncoderSetting(
          iosEncoder: IosEncoder.kAudioFormatOpus,
        ),
      ),
    );

    _clearRecordingVoiceElapsedSeconds();
    _recordedVoiceDuration = 0;
    _recordingVoiceTimer = Timer.periodic(const Duration(seconds: 1), (final Timer t) {
      _recordedVoiceDuration++;
      _setRecordingVoiceElapsedSeconds(_recordedVoiceDuration);
    });

    isRecording(true);
  }

  Future<void> stopRecording() async {
    if (isRecording.value == false) return;

    final path = await recorderController.stop();

    isRecording(false);
    final duration = _recordedVoiceDuration;
    _clearRecordingVoiceElapsedSeconds();
    _recordingVoiceTimer?.cancel();
    
    if (path != null && path.isNotEmpty) {
      recordedVoicePath.value = path;
      recordedVoiceDuration.value = duration;
      _recordedVoiceDuration = 0;
    }
  }

  void sendRecordedVoice() {
    if (recordedVoicePath.value != null && recordedVoiceDuration.value != null) {
      controller.mediaManager.uploadAndSendFile(
        File(recordedVoicePath.value!),
        SupportMessageType.voice,
      );
      clearVoicePreview();
    }
  }

  void clearVoicePreview() {
    recordedVoicePath.value = null;
    recordedVoiceDuration.value = null;
  }

  void _setRecordingVoiceElapsedSeconds(final int seconds) {
    recordingVoiceElapsedSeconds(_formatTime(seconds));
  }

  void _clearRecordingVoiceElapsedSeconds() {
    recordingVoiceElapsedSeconds(_formatTime(0));
  }

  String _formatTime(final int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
