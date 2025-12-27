import 'package:bermooda_business/core/utils/extensions/time_extensions.dart';
import 'package:u/utilities.dart';

import '../../../data/data.dart';
import '../../theme.dart';
import '../../utils/enums/enums.dart';

class WTimeTracking extends StatefulWidget {
  const WTimeTracking({
    required this.timerDto,
    required this.onTapButton,
    this.showButtons = true,
    super.key,
  });

  final TimerReadDto timerDto;
  final Function(TimerStatusCommand command) onTapButton;
  final bool showButtons;

  @override
  State<WTimeTracking> createState() => _WTimeTrackingState();
}

class _WTimeTrackingState extends State<WTimeTracking> {
  Timer? _timer;
  final Rx<TimerReadDto> _timerDto = const TimerReadDto().obs;

  @override
  void initState() {
    super.initState();
    _timerDto(widget.timerDto);
    if (_timerDto.value.status == TimerStatus.running) _startTimer();
    if (_timerDto.value.status == TimerStatus.paused) _pauseTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerDto.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final WTimeTracking oldWidget) {
    if (oldWidget.timerDto != widget.timerDto) {
      _timerDto(widget.timerDto);
      if (_timerDto.value.status == TimerStatus.running) _startTimer();
      if (_timerDto.value.status == TimerStatus.paused) _pauseTimer();
    }
    if (oldWidget.showButtons != widget.showButtons) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  void _startTimer() {
    _timer?.cancel();
    _timerDto.update((val) => val = val?.copyWith(status: TimerStatus.running));
    _timer = Timer.periodic(const Duration(seconds: 1), (final timer) {
      final newState = _timerDto.value.copyWith(elapsedSeconds: _timerDto.value.elapsedSeconds + 1);
      _timerDto(newState);
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _timerDto.update((val) => val = val?.copyWith(status: TimerStatus.paused));
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 10,
        children: [
          Flexible(
            child:
                Text(
                  _timerDto.value.elapsedSeconds.toHoursMinutesSecondsFormat,
                  maxLines: 1,
                ).bodyLarge(
                  overflow: TextOverflow.ellipsis,
                  color: _timerDto.value.status == TimerStatus.running
                      ? AppColors.green
                      : _timerDto.value.status == TimerStatus.paused
                      ? AppColors.orange
                      : null,
                ),
          ),
          if (widget.showButtons &&
              (_timerDto.value.status == TimerStatus.stopped || _timerDto.value.status == TimerStatus.paused)) ...[
            if (_timerDto.value.status == TimerStatus.paused)
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    _button(
                      icon: const Icon(Icons.refresh_rounded, size: 25, color: Colors.white),
                      backgroundColor: AppColors.blue,
                      tooltip: 'RESET',
                      onTap: () => widget.onTapButton(TimerStatusCommand.reset),
                    ),
                    _button(
                      icon: const Icon(Icons.stop_rounded, size: 30, color: Colors.white),
                      backgroundColor: AppColors.red,
                      tooltip: 'STOP',
                      onTap: () => widget.onTapButton(TimerStatusCommand.stop),
                    ),
                    _button(
                      icon: const Icon(Icons.play_arrow_rounded, size: 30, color: Colors.white),
                      backgroundColor: AppColors.orange,
                      tooltip: 'PLAY',
                      onTap: () => widget.onTapButton(TimerStatusCommand.play),
                    ),
                  ],
                ),
              )
            else
              _button(
                icon: const Icon(Icons.play_arrow_rounded, size: 30, color: Colors.white),
                backgroundColor: AppColors.green,
                tooltip: 'PLAY',
                onTap: () => widget.onTapButton(TimerStatusCommand.play),
              ),
          ] else if (_timerDto.value.status == TimerStatus.running)
            _button(
              icon: const Icon(Icons.pause_rounded, size: 30, color: Colors.white),
              backgroundColor: AppColors.orange,
              tooltip: 'PAUSE',
              onTap: () => widget.onTapButton(TimerStatusCommand.pause),
            ),
        ],
      ),
    );
  }

  Widget _button({
    required final VoidCallback onTap,
    required final Widget icon,
    required final String tooltip,
    required final Color backgroundColor,
  }) {
    return IconButton.filled(
      onPressed: onTap,
      icon: icon,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        fixedSize: const Size(40, 40),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
