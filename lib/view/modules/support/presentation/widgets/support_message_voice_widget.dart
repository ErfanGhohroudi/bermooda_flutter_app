import 'dart:math' as math;

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:bermooda_business/core/helpers/open_file_helpers.dart';
import 'package:u/utilities.dart';

import '../../../../../core/utils/extensions/money_extensions.dart';

class SupportMessageVoiceWidget extends StatefulWidget {
  const SupportMessageVoiceWidget({
    required this.url,
    required this.duration,
    required this.isOwn,
    this.fileName,
    super.key,
  });

  final String url;
  final int? duration;
  final bool isOwn;
  final String? fileName;

  @override
  State<SupportMessageVoiceWidget> createState() => _SupportMessageVoiceWidgetState();
}

class _SupportMessageVoiceWidgetState extends State<SupportMessageVoiceWidget> with AutomaticKeepAliveClientMixin {
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
    playerController = PlayerController();
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
    if (!widget.url.startsWith('http')) {
      _localFilePath = widget.url;
      await _initPlayer();
      return;
    }

    final fileName = widget.fileName ?? widget.url.split('/').last;
    final cachedPath = await OpenFileHelpers.getFilePath(fileName);
    if (cachedPath != null) {
      final file = File(cachedPath);
      if (await file.exists()) {
        _localFilePath = cachedPath;
        await _initPlayer();
      }
    }
  }

  Future<void> _downloadAndInitPlayer() async {
    if (_localFilePath != null && !_localFilePath!.startsWith('http')) {
      await _initPlayer();
      return;
    }

    if (_localFilePath != null) {
      await _initPlayer();
      return;
    }

    _isDownloading(true);
    try {
      final fileName = widget.fileName ?? widget.url.split('/').last;
      final downloadedPath = await OpenFileHelpers.downloadFile(
        url: widget.url,
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
        _localFilePath = widget.url;
        await _initPlayer();
      }
    } catch (e) {
      debugPrint('Error downloading voice file: $e');
      _localFilePath = widget.url;
      await _initPlayer();
    } finally {
      _isDownloading(false);
    }
  }

  Future<void> _initPlayer() async {
    if (_localFilePath == null || _isPlayerInitialized.value) return;

    try {
      final style = const PlayerWaveStyle();
      final samples = style.getSamplesForWidth((Get.context?.width ?? 400) / waveformScale);
      await playerController.preparePlayer(
        path: _localFilePath!,
        shouldExtractWaveform: true,
        noOfSamples: samples,
        volume: 1.0,
      );

      // await playerController.setFinishMode(finishMode: FinishMode.pause);

      _currentDurationSubscription = playerController.onCurrentDurationChanged.listen((final duration) {
        _currentPosition(Duration(milliseconds: duration));
      });

      _playerStateSubscription = playerController.onPlayerStateChanged.listen((final state) {
        _isPlaying(state == PlayerState.playing);
      });

      _totalDuration(Duration(milliseconds: await playerController.getDuration(DurationType.max)));
      _isPlayerInitialized(true);
    } catch (e) {
      debugPrint('Error initializing player: $e');
    }
  }

  Future<void> _playPause() async {
    if (!_isPlayerInitialized.value) {
      await _downloadAndInitPlayer();
      if (!_isPlayerInitialized.value) return;
    }

    try {
      final currentState = playerController.playerState;

      if (currentState == PlayerState.playing) {
        await playerController.pausePlayer();
      } else {
        if (currentState == PlayerState.stopped) {
          await playerController.seekTo(0);
          _currentPosition(Duration.zero);
        }
        await playerController.startPlayer();
      }
    } catch (e) {
      debugPrint('Error in play/pause: $e');
      if (_localFilePath != null) {
        try {
          _isPlayerInitialized(false);
          await playerController.preparePlayer(
            path: _localFilePath!,
            shouldExtractWaveform: true,
            volume: 1.0,
          );
          // await playerController.setFinishMode(finishMode: FinishMode.pause);
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

    final sampleValues = List.generate(samples, (final index) {
      final normalizedIndex = index / samples;
      final sinWave1 = math.sin(normalizedIndex * 8 + random.nextDouble() * 2);
      final sinWave2 = math.sin(normalizedIndex * 15 + random.nextDouble() * 3);
      final sinWave3 = math.sin(normalizedIndex * 25 + random.nextDouble() * 4);
      final noise = (random.nextDouble() - 0.5) * 0.3;
      final combined = (sinWave1 * 0.4 + sinWave2 * 0.3 + sinWave3 * 0.2 + noise);
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
