import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../data/dto/conversation_dtos.dart';
import '../pages/messages/conversation_messages_controller.dart';
import 'text_box.dart';
import 'voice_preview_widget.dart';

class MessageInputWidget extends StatelessWidget {
  const MessageInputWidget({
    required this.controller,
    super.key,
  });

  final ConversationMessagesController controller;

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() {
          if (controller.editingMessage.value != null) {
            return _buildEditPreview(context, controller.editingMessage.value!);
          }
          if (controller.repliedMessage.value != null) {
            return _buildReplyPreview(context, controller.repliedMessage.value!);
          }
          return const SizedBox.shrink();
        }),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            width: context.width,
            color: context.theme.cardColor,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: Row(
              children: [
                Flexible(
                  child: Obx(() {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildCurrentInputWidget(context),
                    );
                  }),
                ),
                Obx(() {
                  if (controller.recordedVoicePath.value != null || (controller.isRecording.value == false && controller.messageController.text.trim().isNotEmpty)) {
                    return IconButton(
                      icon: const UImage(AppIcons.sendMessage, size: 30, color: AppColors.primaryColor),
                      // icon: const Icon(Icons.send, color: AppColors.primaryColor),
                      onPressed: () {
                        if (controller.recordedVoicePath.value != null) {
                          controller.sendRecordedVoice();
                          return;
                        }
                        controller.sendMessage();
                      },
                    );
                  }

                  return GestureDetector(
                    onLongPress: controller.startRecording,
                    onLongPressUp: controller.stopRecording,
                    child: Obx(
                      () => CircleAvatar(
                        radius: 20,
                        backgroundColor: controller.isRecording.value ? AppColors.red : AppColors.primaryColor,
                        child: Icon(
                          controller.isRecording.value ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReplyPreview(final BuildContext context, final MessageDto message) {
    return Container(
      width: context.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: context.theme.cardColor,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => controller.clearReplyMessage(),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.scrollToRepliedMessage(message.id),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(message.sender.fullName ?? '').bodyMedium(color: AppColors.primaryColor).bold(),
                    Text(
                      message.text ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).bodyMedium(color: context.theme.hintColor),
                  ],
                ),
              ),
            ),
          ),
          const UImage(AppIcons.reply, width: 25, height: 25, color: AppColors.primaryColor),
        ],
      ),
    );
  }

  Widget _buildEditPreview(final BuildContext context, final MessageDto message) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: context.theme.cardColor,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => controller.clearEditingMessage(),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.scrollToEditingMessage(message.id),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.edit).bodyMedium(color: AppColors.primaryColor).bold(),
                    Text(
                      message.text ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).bodyMedium(color: context.theme.hintColor),
                  ],
                ),
              ),
            ),
          ),
          const UImage(AppIcons.editOutline, width: 25, height: 25, color: AppColors.primaryColor),
        ],
      ),
    );
  }

  Widget _buildCurrentInputWidget(final BuildContext context) {
    if (controller.recordedVoicePath.value != null) {
      return VoicePreviewWidget(controller: controller);
    }

    // If recording, show live waveform
    if (controller.isRecording.value) {
      return Container(
        key: const ValueKey('recording_waveform'),
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          spacing: 8,
          children: [
            Text(controller.recordingVoiceElapsedSeconds.value).bodyMedium(fontSize: 16, color: AppColors.primaryColor).bold(),
            Expanded(
              child: AudioWaveforms(
                size: Size(context.width - 120, 50),
                recorderController: controller.recorderController,
                shouldCalculateScrolledPosition: true,
                waveStyle: const WaveStyle(
                  waveColor: AppColors.primaryColor,
                  extendWaveform: true,
                  showMiddleLine: false,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primaryColor.withAlpha(20),
                ),
                padding: const EdgeInsets.only(left: 18),
                margin: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
          ],
        ),
      );
    }

    // If recorded voice exists, show preview (handled by VoicePreviewWidget above)
    // Otherwise show input box
    return Row(
      children: [
        IconButton(
          icon: UImage(AppIcons.attachment, size: 30, color: Get.isDarkMode ? Colors.white : Colors.black87),
          onPressed: () => controller.handleAttachmentPressed(),
        ),
        Flexible(
          child: WTextBox(
            key: const ValueKey('input_box'),
            controller: controller.messageController,
            onChanged: (final value) {
              controller.sendTypingStatus(value.isNotEmpty);
              controller.isRecording.refresh(); // reset input Widget
            },
          ),
        ),
      ],
    );
  }
}
