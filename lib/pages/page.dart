import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/models/content.dart';
import 'package:lexp/models/user.dart';
import 'package:lexp/models/user_unity.dart';
import 'package:lexp/services/shared_service.dart' as shared;
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:logger/logger.dart';

class PageScreen extends StatefulWidget {
  const PageScreen({super.key, this.user, this.userUnity});

  final UserModel? user;
  final UserUnityModel? userUnity;

  @override
  State<StatefulWidget> createState() => _PageScreenState();
  // TODO: implement seek to position after reopens from shared preferences
}

class _PageScreenState extends State<PageScreen> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  late String _stickyNotes;
  late final Future _future;
  late final List<ContentModel> _contents;
  late ContentModel _currentContent;
  late Duration _savedPosition;
  bool _isPlayerReady = false;
  final _formKey = GlobalKey<FormState>();
  String endedVids = ""; //XXX
  var _logger = Logger();

  void _submitCommand(int idContent) {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _saveNotesCommand(idContent);
    }
  }

  void _saveNotesCommand(int idContent) {
    _logger.d("Saving notes");
    var params = {
      "data": {
        "idUser": widget.userUnity!.idUser,
        "idContent": idContent,
        "notes": _stickyNotes,
      }
    };
  }

  final List<String> _ids = [
    '1xcSDYy3Dl4',
    'K17df81RL9Y',
    'F5tSoaJ93ac',
    '7j7twuejxvU',
    'MGe1GCVZTAA',
  ];

  @override
  void initState() {
    var params = {
      "data": {
        //"idThematicUnit": widget.userUnity!.idThematicUnit,
        "idThematicUnit": 2 //XXX
      }
    };
    _future = rest.RestProvider().callMethod("/cntc/fabtui", params);
    _future.then((value) => {
          _contents = shared.SharedService().getContents(value),
          _currentContent = _contents.first,
          _controller = YoutubePlayerController(
            initialVideoId: _currentContent.multimedia,
            flags: const YoutubePlayerFlags(
              mute: false,
              autoPlay: true,
              disableDragSeek: false,
              loop: false,
              isLive: false,
              forceHD: true,
              enableCaption: false,
            ),
          )..addListener(listener)
        });

    super.initState();
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    //TODO: fetch _stickyNotes from user
    _stickyNotes = "";
    _savedPosition = const Duration(seconds: 0); //TODO: fetch from device
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'), //TODO: pretty this
              ),
              body: Center(
                child: _text("Error:", "${snapshot.error}"),
              ),
            );
          }
          if (snapshot.hasData) {
            return YoutubePlayerBuilder(
              onExitFullScreen: () {
                // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                SystemChrome.setPreferredOrientations(DeviceOrientation.values);
              },
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.purple,
                progressColors: ProgressBarColors(
                  playedColor: AppColors.customPurple,
                  backgroundColor: Colors.purple.withOpacity(0.5),
                  handleColor: AppColors.customPurple,
                ),
                topActions: <Widget>[
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      _controller.metadata.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.outlined_flag,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    onPressed: () {
                      //TODO: report video to admin
                    },
                  ),
                ],
                onReady: () {
                  _isPlayerReady = true;
                  _logger.d('Player is ready.');
                },
                onEnded: (data) {
                  endedVids += '${_videoMetaData.title}, ';
                  _logger.i('OnEnded: ${data.videoId}');
                  if (_contents.indexOf(_currentContent) == _contents.length - 1) {
                    _logger.i("Last video in the list");
                    _controller.seekTo(const Duration(seconds: 0));
                    _controller.pause();
                    return;
                  }
                  _currentContent = _contents[_contents.indexOf(_currentContent) + 1];
                  _controller.load(_currentContent.multimedia);
                },
              ),
              builder: (context, player) => Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'TODO',
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit_note),
                      onPressed: () => _showStickyNotes(),
                    ),
                  ],
                ),
                body: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      color: AppColors.customPurple,
                      child: player,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.skip_previous),
                                color: AppColors.customPurple,
                                onPressed: () {
                                  if (_isPlayerReady) {
                                    if (_contents.indexOf(_currentContent) == 0) {
                                      _logger.i("First video in the list");
                                      _controller.seekTo(const Duration(seconds: 0));
                                      _controller.pause();
                                      return;
                                    }
                                    _currentContent = _contents[_contents.indexOf(_currentContent) - 1];
                                    _controller.load(_currentContent.multimedia);
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                ),
                                color: AppColors.customPurple,
                                onPressed: () {
                                  if (_isPlayerReady) {
                                    if (_controller.value.isPlaying) {
                                      _controller.pause();
                                      shared.SharedService().setVidPosition(_controller.metadata.videoId, _controller.value.position);
                                    } else {
                                      _controller.play();
                                    }
                                    setState(() {});
                                  }
                                },
                              ),
                              IconButton(
                                  icon: const Icon(Icons.skip_next),
                                  color: AppColors.customPurple,
                                  onPressed: () {
                                    if (_isPlayerReady) {
                                      if (_contents.indexOf(_currentContent) == _contents.length - 1) {
                                        _logger.i("Last video in the list");
                                        _showSnackBar("Ultimo contenido del curso");
                                        return;
                                      }
                                      _currentContent = _contents[_contents.indexOf(_currentContent) + 1];
                                      _controller.load(_currentContent.multimedia);
                                    }
                                    endedVids += '${_videoMetaData.title}, ';
                                    _logger.i('Skip Next');
                                  }),
                            ],
                          ),
                          _space,
                          /* AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: _getStateColor(_playerState),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _playerState.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ), */
                          //TODO: EXAMEN // 4 opciones //examen //n preguntas //preguntas -> id correcta
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
                child: SpinKitFadingCube(
              color: AppColors.customPurple,
              size: 42.0,
            ));
          }
        });
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: TextStyle(
          color: AppColors.customPurple,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              color: AppColors.customPurple,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        endedVids += '${_videoMetaData.title}, ';
        _logger.i('ended');
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        _logger.i('paused');
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: AppColors.customPurple,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  bool checkLastFirstVideo(String videoID) {
    if (videoID == _ids.first) {
      return true;
    } else if (videoID == _ids.last) {
      return true;
    } else {
      return false;
    }
  }

  void _showStickyNotes() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      builder: (context) {
        return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                    key: _formKey,
                    child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            children: [
                              _space,
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text('Notas de la clase',
                                    style: TextStyle(color: AppColors.customPurple, fontSize: 20, fontWeight: FontWeight.bold)),
                              ),
                              _space,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Escribe aquí tus notas',
                                    border: InputBorder.none,
                                  ),
                                  onSaved: (value) {
                                    _stickyNotes = value!;
                                  },
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                ),
                              ),
                              _space,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.customPurple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.customPurple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _submitCommand(_currentContent.idContent);
                                      _showSnackBar('Notas guardadas');
                                    },
                                    child: const Text('Guardar'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ]))));
      },
    );
  }
}
