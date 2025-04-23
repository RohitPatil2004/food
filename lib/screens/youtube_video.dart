import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPage extends StatefulWidget {
  final String videoId;
  final String recipeTitle;

  const YoutubeVideoPage({
    Key? key,
    required this.videoId,
    required this.recipeTitle,
  }) : super(key: key);

  @override
  State<YoutubeVideoPage> createState() => _YoutubeVideoPageState();
}

class _YoutubeVideoPageState extends State<YoutubeVideoPage> {
  late YoutubePlayerController _controller;
  bool _isMuted = false;
  bool _isPlaying = true;
  double _volume = 100;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.recipeTitle} Video'),
        backgroundColor: Colors.red[700],
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressColors: const ProgressBarColors(
                playedColor: Colors.red,
                handleColor: Colors.redAccent,
              ),
              onReady: () {
                _controller.addListener(() {
                  if (_controller.value.isPlaying != _isPlaying) {
                    setState(() {
                      _isPlaying = _controller.value.isPlaying;
                    });
                  }
                });
              },
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.red[700],
                        size: 32,
                      ),
                      onPressed: () {
                        _isPlaying
                            ? _controller.pause()
                            : _controller.play();
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.red[700],
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          _isMuted = !_isMuted;
                          _isMuted ? _controller.mute() : _controller.setVolume(_volume.round());
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.replay_10,
                        color: Colors.red[700],
                        size: 32,
                      ),
                      onPressed: () {
                        _controller.seekTo(
                          Duration(
                            seconds: _controller.metadata.duration.inSeconds - 10,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.forward_10,
                        color: Colors.red[700],
                        size: 32,
                      ),
                      onPressed: () {
                        _controller.seekTo(
                          Duration(
                            seconds: _controller.metadata.duration.inSeconds + 10,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Slider(
                  value: _volume,
                  min: 0,
                  max: 100,
                  activeColor: Colors.red[700],
                  inactiveColor: Colors.grey,
                  onChanged: (value) {
                    setState(() {
                      _volume = value;
                      _controller.setVolume(value.round());
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}