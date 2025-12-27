import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../../core/theme.dart';
import '../pages/messages/conversation_messages_controller.dart';

class VoicePreviewWidget extends StatefulWidget {
  const VoicePreviewWidget({
    required this.controller,
    super.key,
  });

  final ConversationMessagesController controller;

  @override
  State<VoicePreviewWidget> createState() => _VoicePreviewWidgetState();
}

class _VoicePreviewWidgetState extends State<VoicePreviewWidget> {
  late final PlayerController playerController;
  final Rx<bool> _isPlaying = false.obs;
  final Rx<Duration> _currentPosition = Duration.zero.obs;
  final Rx<Duration> _totalDuration = Duration.zero.obs;
  StreamSubscription? _currentDurationSubscription;
  StreamSubscription? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    playerController = PlayerController()..overrideAudioSession = true;
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    final voicePath = widget.controller.recordedVoicePath.value;
    if (voicePath == null) return;

    try {
      final style = const PlayerWaveStyle();
      final samples = style.getSamplesForWidth((navigatorKey.currentContext?.width ?? 400) / 3);
      await playerController.preparePlayer(
        path: voicePath,
        shouldExtractWaveform: true,
        noOfSamples: samples,
        volume: 1.0,
      );

      await playerController.setFinishMode(finishMode: FinishMode.pause);

      // Listen to current duration changes
      _currentDurationSubscription = playerController.onCurrentDurationChanged.listen((final duration) {
        _currentPosition(Duration(milliseconds: duration));
      });

      // Listen to player state changes
      _playerStateSubscription = playerController.onPlayerStateChanged.listen((final state) {
        _isPlaying(state == PlayerState.playing);
      });

      _totalDuration(Duration(milliseconds: await playerController.getDuration(DurationType.max)));
    } catch (e) {
      debugPrint('Error initializing preview player: $e');
    }
  }

  Future<void> _playPause() async {
    try {
      final currentState = playerController.playerState;

      if (currentState == PlayerState.playing) {
        await playerController.pausePlayer();
      } else {
        // If stopped, ensure we're at the beginning
        if (currentState == PlayerState.stopped) {
          // Reset position to beginning
          await playerController.seekTo(0);
          _currentPosition(Duration.zero);
        }
        // Start or resume playback
        await playerController.startPlayer();
      }
    } catch (e) {
      debugPrint('Error in play/pause: $e');
      // If startPlayer fails, try to prepare again
      final voicePath = widget.controller.recordedVoicePath.value;
      if (voicePath != null) {
        try {
          await playerController.preparePlayer(
            path: voicePath,
            shouldExtractWaveform: true,
            volume: 1.0,
          );
          await playerController.setFinishMode(finishMode: FinishMode.stop);
          await playerController.seekTo(0);
          await playerController.startPlayer();
        } catch (e2) {
          debugPrint('Error retrying play: $e2');
        }
      }
    }
  }

  @override
  void dispose() {
    _currentDurationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    playerController.dispose();
    _isPlaying.close();
    _currentPosition.close();
    _totalDuration.close();
    super.dispose();
  }

  String _formatDuration(final Duration duration) {
    String twoDigits(final int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () {
        if (widget.controller.recordedVoicePath.value == null) {
          return const SizedBox.shrink();
        }

        return Directionality(
          key: const ValueKey('preview_recorded_voice_waveform'),
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              IconButton(
                onPressed: widget.controller.clearVoicePreview,
                icon: const UImage(AppIcons.delete, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.red,
                ),
              ),
              IconButton(
                onPressed: _playPause,
                icon: Icon(
                  _isPlaying.value ? CupertinoIcons.pause_solid : CupertinoIcons.play_arrow_solid,
                ),
                style: IconButton.styleFrom(backgroundColor: context.theme.primaryColor, foregroundColor: Colors.white),
              ),
              Container(
                decoration: BoxDecoration(
                  color: context.theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 2),
                margin: const EdgeInsetsDirectional.symmetric(horizontal: 2, vertical: 10),
                child: AudioFileWaveforms(
                  size: Size(
                    context.width / 3,
                    50,
                  ),
                  playerController: playerController,
                  waveformType: WaveformType.fitWidth,
                  playerWaveStyle: PlayerWaveStyle(
                    fixedWaveColor: Colors.grey.withAlpha(150),
                    liveWaveColor: AppColors.primaryColor,
                  ),
                  enableSeekGesture: true,
                ),
              ),
              Text(_formatDuration(_currentPosition.value), textAlign: TextAlign.center).titleMedium().expanded(),
            ],
          ),
        );
      },
    );
  }
}
