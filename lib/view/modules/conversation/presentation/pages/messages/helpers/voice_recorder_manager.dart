import 'dart:io';
import 'dart:math';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:vibration/vibration.dart';
import 'package:u/utilities.dart';

import '../conversation_messages_controller.dart';

class VoiceRecorderManager {
  VoiceRecorderManager(this.controller);

  final ConversationMessagesController controller;

  Timer? _recordingVoiceTimer;
  int _recordedVoiceDuration = 0;

  Future<void> startRecording() async {
    if (controller.isAnonymousBot) return;
    final status = await controller.recorderController.checkPermission();
    if (status == false) return;
    Directory tempDir = Directory.systemTemp;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000);
    String path = '${tempDir.path}/recorded_audio_${timestamp}_$random.aac';

    // ویبره هنگام شروع ضبط
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 50); // ویبره به مدت 200 میلی‌ثانیه
    }

    // Start recording with RecorderController for live waveform
    await controller.recorderController.record(
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

    // شروع تایمر
    clearRecordingVoiceElapsedSeconds();
    _recordedVoiceDuration = 0;
    _recordingVoiceTimer = Timer.periodic(const Duration(seconds: 1), (
      final Timer t,
    ) {
      _recordedVoiceDuration++;
      setRecordingVoiceElapsedSeconds(_recordedVoiceDuration);
    });

    controller.isRecording(true);
  }

  Future<void> stopRecording() async {
    if (controller.isAnonymousBot) return;
    // Stop recording with RecorderController
    final path = await controller.recorderController.stop();

    controller.isRecording(false);
    final duration = _recordedVoiceDuration;
    clearRecordingVoiceElapsedSeconds();
    _recordingVoiceTimer?.cancel();
    if (path != null && path.isNotEmpty) {
      // Show preview instead of sending immediately
      controller.recordedVoicePath.value = path;
      controller.recordedVoiceDuration.value = duration;
      _recordedVoiceDuration = 0;
    }
  }

  void sendRecordedVoice() {
    if (controller.isAnonymousBot) return;
    if (controller.recordedVoicePath.value != null &&
        controller.recordedVoiceDuration.value != null) {
      controller.sendVoice(File(controller.recordedVoicePath.value!), controller.recordedVoiceDuration.value);
      clearVoicePreview();
    }
  }

  void clearVoicePreview() {
    controller.recordedVoicePath.value = null;
    controller.recordedVoiceDuration.value = null;
  }

  void setRecordingVoiceElapsedSeconds(final int seconds) {
    controller.recordingVoiceElapsedSeconds(formatTime(seconds));
  }

  void clearRecordingVoiceElapsedSeconds() {
    controller.recordingVoiceElapsedSeconds(formatTime(0));
  }

  String formatTime(final int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void dispose() {
    _recordingVoiceTimer?.cancel();
  }
}

