import 'dart:io';
import 'dart:math' as math;

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bermooda_business/core/utils/extensions/money_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:u/utilities.dart';

import '../../../../../core/helpers/open_file_helpers.dart';
import '../../data/dto/conversation_dtos.dart';

class MessageVoiceWidget extends StatefulWidget {
  const MessageVoiceWidget({
    required this.attachment,
    required this.duration,
    required this.isOwn,
    super.key,
  });

  final MessageAttachmentDto attachment;
  final int? duration;
  final bool isOwn;

  @override
  State<MessageVoiceWidget> createState() => _MessageVoiceWidgetState();
}

class _MessageVoiceWidgetState extends State<MessageVoiceWidget> with AutomaticKeepAliveClientMixin {
  late final String _voiceUrl;
  late final PlayerController playerController;
  final Rx<bool> _isPlaying = false.obs;
  final Rx<Duration> _currentPosition = Duration.zero.obs;
  final Rx<Duration> _totalDuration = Duration.zero.obs;
  final Rx<bool> _isDownloading = false.obs;
  final Rx<double> _downloadProgress = 0.0.obs;
  final Rx<bool> _isPlayerInitialized = false.obs;
  String? _localFilePath;
  StreamSubscription? _currentDurationSubscription;
  StreamSubscription? _playerStateSubscription;

  static const double waveformScale = 1.7;

  @override
  void initState() {
    super.initState();
    _voiceUrl = widget.attachment.fileUrl;
    playerController = PlayerController()..overrideAudioSession = true;
    // چک کن آیا فایل قبلاً دانلود شده و player را initialize کن
    _checkCachedFileAndInit();
    if (widget.duration != null) {
      _totalDuration(Duration(seconds: widget.duration!));
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
    _isPlayerInitialized.close();
    super.dispose();
  }

  Future<void> _checkCachedFileAndInit() async {
    // اگر URL محلی است (شروع با / یا file://) مستقیماً استفاده کن
    if (!_voiceUrl.startsWith('http')) {
      _localFilePath = _voiceUrl;
      await _initPlayer();
      return;
    }

    // چک کن آیا فایل قبلاً دانلود شده
    final fileName = widget.attachment.fileName;
    final cachedPath = await OpenFileHelpers.getFilePath(fileName);
    if (cachedPath != null) {
      final file = File(cachedPath);
      if (await file.exists()) {
        _localFilePath = cachedPath;
        // اگر فایل پیدا شد، player را initialize کن
        await _initPlayer();
      }
    }
  }

  Future<void> _downloadAndInitPlayer() async {
    // اگر فایل محلی است، مستقیماً initialize کن
    if (_localFilePath != null && !_localFilePath!.startsWith('http')) {
      await _initPlayer();
      return;
    }

    // اگر فایل قبلاً دانلود شده، از cache استفاده کن
    if (_localFilePath != null) {
      await _initPlayer();
      return;
    }

    // دانلود فایل
    _isDownloading(true);
    try {
      final fileName = widget.attachment.fileName;
      final downloadedPath = await OpenFileHelpers.downloadFile(
        url: _voiceUrl,
        fileName: fileName,
        onProgress: (final progress) {
          _downloadProgress(progress);
        },
      );

      if (downloadedPath != null) {
        _localFilePath = downloadedPath;
        await _initPlayer();
      } else {
        debugPrint('Failed to download voice file');
        // اگر دانلود شکست خورد، سعی کن مستقیماً از URL استفاده کنی
        _localFilePath = _voiceUrl;
        await _initPlayer();
      }
    } catch (e) {
      debugPrint('Error downloading voice file: $e');
      // اگر دانلود شکست خورد، سعی کن مستقیماً از URL استفاده کنی
      _localFilePath = _voiceUrl;
      await _initPlayer();
    } finally {
      _isDownloading(false);
    }
  }

  Future<void> _initPlayer() async {
    if (_localFilePath == null || _isPlayerInitialized.value) return;

    try {
      final style = const PlayerWaveStyle();
      final samples = style.getSamplesForWidth((navigatorKey.currentContext?.width ?? 400) / waveformScale);
      await playerController.preparePlayer(
        path: _localFilePath!,
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

      // Get initial duration from widget if available
      _totalDuration(Duration(milliseconds: await playerController.getDuration(DurationType.max)));
      _isPlayerInitialized(true);
    } catch (e) {
      debugPrint('Error initializing player: $e');
    }
  }

  Future<void> _playPause() async {
    // اگر player initialize نشده، ابتدا دانلود و initialize کن
    if (!_isPlayerInitialized.value) {
      await _downloadAndInitPlayer();
      // اگر بعد از دانلود هم initialize نشد، خروج
      if (!_isPlayerInitialized.value) return;
    }

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
      if (_localFilePath != null) {
        try {
          _isPlayerInitialized(false);
          await playerController.preparePlayer(
            path: _localFilePath!,
            shouldExtractWaveform: true,
            volume: 1.0,
          );
          await playerController.setFinishMode(finishMode: FinishMode.pause);
          await playerController.seekTo(0);
          await playerController.startPlayer();
          _isPlayerInitialized(true);
        } catch (e2) {
          debugPrint('Error retrying play: $e2');
        }
      }
    }
  }

  String _formatDuration(final Duration duration) {
    String twoDigits(final int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Widget _buildPlaceholderWaveform(final BuildContext context) {
    final style = const PlayerWaveStyle();
    final samples = style.getSamplesForWidth(context.width / waveformScale);
    final random = math.Random(DateTime.now().millisecondsSinceEpoch);

    // ایجاد یک لیست نمونه از مقادیر waveform با الگوی نامنظم و طبیعی
    final sampleValues = List.generate(samples, (final index) {
      // ترکیب چند الگوی مختلف برای طبیعی‌تر شدن
      final normalizedIndex = index / samples;

      // الگوی اول: موج سینوسی با فرکانس‌های مختلف
      final sinWave1 = math.sin(normalizedIndex * 8 + random.nextDouble() * 2);
      final sinWave2 = math.sin(normalizedIndex * 15 + random.nextDouble() * 3);
      final sinWave3 = math.sin(normalizedIndex * 25 + random.nextDouble() * 4);

      // الگوی دوم: نویز تصادفی
      final noise = (random.nextDouble() - 0.5) * 0.3;

      // ترکیب الگوها با وزن‌های مختلف
      final combined = (sinWave1 * 0.4 + sinWave2 * 0.3 + sinWave3 * 0.2 + noise);

      // تبدیل به محدوده 0.2 تا 0.95 برای طبیعی‌تر شدن
      final waveValue = ((combined + 1) / 2 * 0.75 + 0.2).clamp(0.2, 0.95);

      return (waveValue * 100).round();
    });

    final fixedColor = widget.isOwn ? Colors.white.withAlpha(150) : (context.isDarkMode ? Colors.white.withAlpha(150) : Colors.grey.withAlpha(150));
    final spacing = 5.0;
    final waveThickness = 2.0;
    final width = context.width / waveformScale;
    final height = 50.0;
    final barWidth = (width - (samples - 1) * spacing) / samples;

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _WaveformPlaceholderPainter(
          samples: sampleValues,
          fixedColor: fixedColor,
          spacing: spacing,
          waveThickness: waveThickness,
          barWidth: barWidth,
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return Obx(
      () {
        if (_isDownloading.value) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: _downloadProgress.value / 100,
                  backgroundColor: widget.isOwn ? Colors.white12 : context.theme.dividerColor,
                  color: widget.isOwn ? Colors.white : context.theme.primaryColor,
                ),
                const SizedBox(height: 8),
                Text('${_downloadProgress.value.percentageFormatted}%').bodySmall(
                  color: widget.isOwn ? Colors.white : null,
                ),
              ],
            ),
          );
        }

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(_isPlaying.value ? CupertinoIcons.pause_solid : CupertinoIcons.play_arrow_solid),
                onPressed: _playPause,
                style: IconButton.styleFrom(
                  backgroundColor: widget.isOwn ? Colors.white : context.theme.primaryColor,
                  foregroundColor: widget.isOwn ? context.theme.primaryColor : Colors.white,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isPlayerInitialized.value
                        ? AudioFileWaveforms(
                            size: Size(
                              context.width / waveformScale,
                              50,
                            ),
                            playerController: playerController,
                            waveformType: WaveformType.fitWidth,
                            playerWaveStyle: PlayerWaveStyle(
                              fixedWaveColor:
                                  widget.isOwn ? Colors.white.withAlpha(150) : (context.isDarkMode ? Colors.white.withAlpha(150) : Colors.grey.withAlpha(150)),
                              liveWaveColor: widget.isOwn ? Colors.white : context.theme.primaryColor,
                              seekLineColor: widget.isOwn ? Colors.white : context.theme.primaryColor,
                            ),
                            enableSeekGesture: true,
                          )
                        : _buildPlaceholderWaveform(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(_currentPosition.value)).bodyMedium(color: widget.isOwn ? Colors.white : null),
                        Text(_formatDuration(_totalDuration.value)).bodyMedium(color: widget.isOwn ? Colors.white : null),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _WaveformPlaceholderPainter extends CustomPainter {
  _WaveformPlaceholderPainter({
    required this.samples,
    required this.fixedColor,
    required this.spacing,
    required this.waveThickness,
    required this.barWidth,
  });

  final List<int> samples;
  final Color fixedColor;
  final double spacing;
  final double waveThickness;
  final double barWidth;

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()
      ..color = fixedColor
      ..strokeWidth = waveThickness
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final maxHeight = size.height * 0.8;

    for (int i = 0; i < samples.length; i++) {
      final x = i * (barWidth + spacing) + barWidth / 2;
      final height = (samples[i] / 100) * maxHeight;
      final startY = centerY - height / 2;
      final endY = centerY + height / 2;

      canvas.drawLine(
        Offset(x, startY),
        Offset(x, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(final _WaveformPlaceholderPainter oldDelegate) => false;
}
