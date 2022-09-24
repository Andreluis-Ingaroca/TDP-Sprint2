import 'package:flutter/material.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/models/notes.dart';
import 'package:lexp/models/user.dart';
import 'package:lexp/widgets/gradient_text.dart';
import 'package:lexp/services/rest_provider.dart' as rest;

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key, required this.user, required this.notes, required this.tittle});

  final UserModel user;
  final List<NotesModel> notes;
  final String tittle;

  @override
  State<StatefulWidget> createState() {
    return _NoteListScreenState();
  }
}

class _NoteListScreenState extends State<NoteListScreen> {
  late NotesModel _stickyNotes;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _submitCommand(int index) {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      _saveNotesCommand(index);
    }
  }

  void _saveNotesCommand(int index) {
    var params = {"data": _stickyNotes.toJson()};
    rest.RestProvider().callMethod("/nc/sn", params).then((savedNotes) {
      setState(() {
        widget.notes[index] = _stickyNotes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GradientText(
          widget.tittle,
          gradient: AppColors.textGradient,
        ),
      ),
      body: Center(
        child: ListView.separated(
            itemCount: widget.notes.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.customPurple, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  subtitle: Text(widget.notes[index].notes.toString()),
                  title: Text(widget.notes[index].content!.contentName.toString()),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Form(
                              key: _formKey,
                              child: AlertDialog(
                                title: Text(widget.notes[index].content!.contentName.toString()),
                                content: TextFormField(
                                  validator: (value) => value!.isEmpty ? 'Ingrese una nota' : null,
                                  controller: TextEditingController(text: widget.notes[index].notes.toString()),
                                  decoration: const InputDecoration(
                                    hintText: 'Escribe aquí tus notas',
                                    border: OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    _stickyNotes = widget.notes[index];
                                    _stickyNotes.notes = value!;
                                  },
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.customPurple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _submitCommand(index);
                                    },
                                    child: const Text('Guardar'),
                                  ),
                                  TextButton(
                                    child: const Text("Cerrar"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ));
                        });
                  },
                ),
              );
            }),
      ),
    );
  }
}
