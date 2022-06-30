import 'dart:async';

import 'package:flutter/material.dart';

import 'widgets/button_widget.dart';

// got it from Johannes Mike (YouTube) [Flutter Tutorial - Simple Stopwatch Timer [2021] Countdown & Countup Timer]

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  static const countdownDuration = Duration(minutes: 10);
  Duration duration = const Duration();
  Timer? timer;

  bool isCountdown = false;

  @override
  void initState() {
    super.initState();

    reset();
  }

  void reset() {
    setState(() {
      if (isCountdown) {
        setState(() {
          duration = countdownDuration;
        });
      } else {
        duration = const Duration();
      }
    });
  }

  void addTime() {
    final addSeconds = isCountdown ? -1 : 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => addTime(),
    );
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    setState(() {
      timer?.cancel();
    });
  }

  Widget _buildTimeCard({
    required String time,
    required String header,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            time,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 72.0),
          ),
        ),
        const SizedBox(height: 24.0),
        Text(
          header,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeCard(time: hours, header: 'HOURS'),
        const SizedBox(width: 8.0),
        _buildTimeCard(time: minutes, header: 'MINUTES'),
        const SizedBox(width: 8.0),
        _buildTimeCard(time: seconds, header: 'SECONDS'),
      ],
    );
  }

  Widget _buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;

    return isRunning || !isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: isRunning ? 'PAUSE' : 'RESUME',
                onClicked: () {
                  if (isRunning) {
                    stopTimer(resets: false);
                  } else {
                    startTimer(resets: false);
                  }
                },
              ),
              const SizedBox(width: 12.0),
              ButtonWidget(
                text: 'CANCEL',
                onClicked: stopTimer,
              ),
            ],
          )
        : ButtonWidget(
            text: 'Start Timer!',
            color: Colors.black,
            backgroundColor: Colors.white,
            onClicked: () {
              startTimer();
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTime(),
          const SizedBox(height: 80.0),
          _buildButtons(),
        ],
      ),
    );
  }
}
