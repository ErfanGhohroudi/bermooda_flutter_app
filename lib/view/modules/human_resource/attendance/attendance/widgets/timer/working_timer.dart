import 'package:u/utilities.dart';

class WorkingTimer extends StatefulWidget {
  const WorkingTimer({
    required this.elapsedSeconds,
    required this.style,
    super.key,
  });

  final int? elapsedSeconds;
  final TextStyle? style;

  @override
  State<WorkingTimer> createState() => _WorkingTimerState();
}

class _WorkingTimerState extends State<WorkingTimer> {
  late Timer _timer;
  late int _elapsedSeconds;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _elapsedSeconds = widget.elapsedSeconds ?? 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (final _) {
      if (mounted == false) return;
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  String formatDuration(final int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final secs = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  @override
  Widget build(final BuildContext context) {
    return Text(formatDuration(_elapsedSeconds), style: widget.style);
  }
}
