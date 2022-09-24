import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lexp/core/res/app.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/models/content.dart';
import 'package:lexp/models/notes.dart';
import 'package:lexp/models/user.dart';
import 'package:lexp/models/user_unity.dart';
import 'package:lexp/services/shared_service.dart' as shared;
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/widgets/gradient_text.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PageScreen extends StatefulWidget {
  const PageScreen({super.key, required this.user, required this.userUnity});

  final UserModel user;
  final UserUnityModel userUnity;

  @override
  State<StatefulWidget> createState() => _PageScreenState();
  // TODO: implement seek to position after reopens from shared preferences
}

class _PageScreenState extends State<PageScreen> {
  late YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '8giBPUpzKRw',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  late NotesModel _stickyNotes;
  late final TextEditingController _stickyNoteController = TextEditingController(text: '');
  late final Future _future;
  late final List<ContentModel> _contents;
  late ContentModel _currentContent;
  late Duration _savedPosition;
  bool _isPlayerReady = false;
  final _formKey = GlobalKey<FormState>();

  void _submitCommand(int idContent) {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      _saveNotesCommand(idContent);
    }
  }

  void _saveProgress(int pos) {
    UserUnityModel prog = widget.userUnity;
    if (prog.advQtty < pos) {
      //only save if the new position is greater than the old one
      prog.advQtty = pos;
      var params = {"data": prog.toJson()};
      rest.RestProvider().callMethod("/uuc/sue", params).then((value) {});
    }
  }

  void _saveNotesCommand(int idContent) {
    var params = {"data": _stickyNotes.toJson()};
    rest.RestProvider().callMethod("/nc/sn", params).then((savedNotes) {
      _stickyNotes = NotesModel.fromJson(savedNotes.data["data"]);
    });
  }

  @override
  void initState() {
    var params = {
      "data": {"idThematicUnit": widget.userUnity.idThematicUnit}
    };
    _future = rest.RestProvider().callMethod("/cntc/fabtui", params);
    _future.then((value) => {
          _contents = shared.SharedService().getContents(value),
          _currentContent = _contents[widget.userUnity.advQtty],
          getNotes(),
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
    _savedPosition = const Duration(seconds: 0); //TODO: fetch from device
  }

  void getNotes() {
    _stickyNotes = NotesModel(
      AppConstants.defaultStatus,
      _currentContent,
      idContent: _currentContent.idContent,
      idUxU: widget.userUnity.idUxU,
      notes: '',
    );

    var params = {"data": _stickyNotes.toJson()};

    rest.RestProvider().callMethod("/nc/gn", params).then((value) {
      if (value.data["data"] != null) {
        _stickyNotes = NotesModel.fromJson(value.data["data"]);
      }
      _stickyNoteController.value = _stickyNoteController.value.copyWith(
        text: _stickyNotes.notes,
        selection: TextSelection.collapsed(offset: _stickyNotes.notes.length),
      );
    });
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
                },
                onEnded: (data) {
                  _controller.seekTo(const Duration(seconds: 0));
                  _controller.pause();
                  _saveProgress(_contents.indexOf(_currentContent) + 1);
                  return;
                },
              ),
              builder: (context, player) => Scaffold(
                appBar: AppBar(
                  title: GradientText(
                    _currentContent.contentName,
                    gradient: AppColors.textGradient,
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
                                icon: const Icon(Icons.skip_previous, size: 37),
                                color: AppColors.customPurple,
                                onPressed: () {
                                  if (_isPlayerReady) {
                                    if (_contents.indexOf(_currentContent) == 0) {
                                      _controller.seekTo(const Duration(seconds: 0));
                                      _controller.pause();
                                      return;
                                    }
                                    _currentContent = _contents[_contents.indexOf(_currentContent) - 1];
                                    _controller.load(_currentContent.multimedia);
                                    getNotes();
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow, size: 37),
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
                                  icon: const Icon(Icons.skip_next, size: 37),
                                  color: AppColors.customPurple,
                                  onPressed: () {
                                    if (_isPlayerReady) {
                                      if (_contents.indexOf(_currentContent) == _contents.length - 1) {
                                        _showSnackBar("Ultimo contenido del curso");
                                        return;
                                      }
                                      _currentContent = _contents[_contents.indexOf(_currentContent) + 1];
                                      _controller.load(_currentContent.multimedia);
                                      getNotes();
                                    }
                                  }),
                            ],
                          ),
                          AppConstants.space,
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: AppColors.customPurple,
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
                          ),
                          Placeholder(),
                          //_examBuilder(_currentContent),
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
                color: AppColors.drawerColor,
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
                              AppConstants.space,
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text('Notas de la clase',
                                    style: TextStyle(color: AppColors.customPurple, fontSize: 20, fontWeight: FontWeight.bold)),
                              ),
                              AppConstants.space,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (value) => value!.isEmpty ? 'Ingrese una nota' : null,
                                  controller: _stickyNoteController,
                                  decoration: const InputDecoration(
                                    hintText: 'Escribe aquí tus notas',
                                    border: InputBorder.none,
                                  ),
                                  onSaved: (value) {
                                    _stickyNotes.notes = value!;
                                  },
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                ),
                              ),
                              AppConstants.space,
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

  /* Widget _examBuilder(final ContentModel data) {
    ExamModel exam = data.listOfExamen!;
    return Column( //TODO
      children: [
        AppConstants.space,
        Text(
          'Examen',
          style: TextStyle(color: AppColors.customPurple, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        AppConstants.space,
        /* Text(
          'Preguntas: ${exam.listOfPreguntas!.length}',
          style: TextStyle(color: AppColors.customPurple, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        AppConstants.space,
        Text(
          'Respuestas: ${exam.listOfPreguntas![0].listOfRespuestas!.length}',
          style: TextStyle(color: AppColors.customPurple, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        AppConstants.space,
        Text(
          'Respuesta correcta: ${exam.listOfPreguntas![0].listOfRespuestas![0].idRespuesta}',
          style: TextStyle(color: AppColors.customPurple, fontSize: 16, fontWeight: FontWeight.bold),
        ), */
        AppConstants.space,
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.customPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
          onPressed: () {
            _showStickyNotes();
          },
          child: const Text('Responder'),
        ),
      ],
    );
  } */
}
