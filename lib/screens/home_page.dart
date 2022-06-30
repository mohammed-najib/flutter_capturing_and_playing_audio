import 'package:flutter/material.dart';

import '../apis/sound_player.dart';
import '../apis/sound_recorder.dart';
import 'widgets/timer_widget.dart';

// got it from Johannes Mike (YouTube) [Flutter Tutorial - Making An Audio Player App [2021]]

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final timerController = TimerController();
  final recorder = SoundRecorder();
  final player = SoundPlayer();

  @override
  void initState() {
    super.initState();

    recorder.init();
    player.init();
  }

  @override
  void dispose() {
    recorder.dispose();
    player.dispose();

    super.dispose();
  }

  Widget _buildStart() {
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? 'STOP' : 'START';
    final primary = isRecording ? Colors.red : Colors.white;
    final onPrimary = isRecording ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      onPressed: () async {
        await recorder.toggleRecording();
        final isRecording = recorder.isRecording;

        setState(() {});

        if (isRecording) {
          timerController.startTimer();
        } else {
          timerController.stopTimer();
        }
      },
      icon: Icon(icon),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(175.0, 50.0),
        primary: primary,
        onPrimary: onPrimary,
      ),
    );
  }

  Widget _buildPlay() {
    final isPlaying = player.isPlaying;
    final icon = isPlaying ? Icons.stop : Icons.play_arrow;
    final text = isPlaying ? 'Stop Playing' : 'Play Recording';

    return ElevatedButton.icon(
      onPressed: () async {
        await player.togglePlaying(
          whenFinished: () {
            setState(() {
              //
            });
          },
        );

        setState(() {});
      },
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(175.0, 50.0),
        primary: Colors.white,
        onPrimary: Colors.black,
      ),
    );
  }

  Widget _buildPlayer() {
    final text = recorder.isRecording ? 'Now Recording' : 'Press To Record';
    // final animate = recorder.isRecording;

    return CircleAvatar(
      radius: 100.0,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 92.0,
        backgroundColor: Colors.indigo.shade900.withBlue(70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mic,
              size: 32.0,
            ),
            TimerWidget(controller: timerController),
            const SizedBox(height: 8.0),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Audio Recorder'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPlayer(),
          const SizedBox(height: 32.0),
          Container(
            alignment: Alignment.center,
            child: _buildStart(),
          ),
          const SizedBox(height: 12.0),
          Container(
            alignment: Alignment.center,
            child: _buildPlay(),
          ),
        ],
      ),
    );
  }
}
