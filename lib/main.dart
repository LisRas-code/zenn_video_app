import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Video demo flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _controller;
  bool initSwitch = false;
  bool complate = false;
  bool playSwitch = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initVideoPlayer() async {
    _controller = VideoPlayerController.asset('assets/test_video.mp4');
    await _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return initSwitch
        ? !complate
            ? Scaffold(
                appBar: AppBar(
                  title: Text("${widget.title}"),
                ),
                body: const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text("ローディング中"),
                  ],
                )),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text("${widget.title}"),
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      // 動画を表示
                      child: VideoPlayer(_controller),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            // 動画を最初から再生
                            _controller
                                .seekTo(Duration.zero)
                                .then((_) => _controller.play());
                            playSwitch = true;
                            setState(() {});
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                        playSwitch
                            ? IconButton(
                                onPressed: () {
                                  // 動画を一時停止
                                  _controller.pause();
                                  playSwitch = !playSwitch;
                                  setState(() {});
                                },
                                icon: const Icon(Icons.pause),
                              )
                            : IconButton(
                                onPressed: () {
                                  // 動画を再生
                                  _controller.play();
                                  playSwitch = !playSwitch;
                                  setState(() {});
                                },
                                icon: const Icon(Icons.play_arrow),
                              )
                      ],
                    ),
                  ],
                ),
              )
        : Scaffold(
            appBar: AppBar(
              title: Text("${widget.title}"),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                initSwitch = true;
                setState(() {});
                await _initVideoPlayer();
                complate = true;
                setState(() {});
              },
              child: const Icon(Icons.play_circle_outline),
            ),
          );
  }
}
