import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteappusingapi/app/componets/curd.dart';

import '../../main.dart';
import '../componets/customtext.dart';
import '../componets/valid.dart';
import '../constant/linkapi.dart';

class EditNote extends StatefulWidget {
  final note;
  EditNote({Key? key, required this.note}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> with Curd {
  File? myfile;
  bool isloading = false;
  Color _color = Colors.red;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  @override
  void initState() {
    _titleController.text = widget.note['notes_title'];
    _descriptionController.text = widget.note['notes_content'];

    super.initState();
  }

  editNotes() async {
    if (_formKey.currentState!.validate()) {
      isloading = true;
      setState(() {});
      ;
      var response;
      if (myfile == null) {
        response = await postrequest(
          linkUpdate,
          {
            'title': _titleController.text,
            'content': _descriptionController.text,
            'id': widget.note['notes_id'].toString(),
            'imagename': widget.note['notes_image'].toString()
          },
        );
      } else {
        response = await postRequestWithFile(
            linkUpdate,
            {
              'title': _titleController.text,
              'content': _descriptionController.text,
              'imagename': widget.note['notes_image'].toString(),
              'id': widget.note['notes_id'].toString(),
            },
            myfile!);
      }

      if (response['status'] == 'success') {
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } else {
        return AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'خطأ',
            desc: response['message'],
            btnOkOnPress: () {
              Navigator.of(context).pop();
            },
            btnOkIcon: Icons.check_circle,
            btnOkColor: Colors.red)
          ..show();
      }

      return response;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Note'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: isloading
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      CustomTextFormSign(
                        validator: (val) {
                          return valid(val!, 1, 40);
                        },
                        hintText: 'title',
                        lableText: 'title',
                        controller: _titleController,
                      ),
                      CustomTextFormSign(
                        validator: (val) {
                          return valid(val!, 1, 11111);
                        },
                        hintText: 'content',
                        lableText: 'content',
                        controller: _descriptionController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 100,
                                  child: Column(children: [
                                    InkWell(
                                      onTap: () async {
                                        XFile? xfile = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        Navigator.of(context).pop();
                                        myfile = File(xfile!.path);

                                        setState(() {
                                          _color = Colors.green;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'Choose From Gallery',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        XFile? xfile = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.camera);
                                        Navigator.of(context).pop();
                                        myfile = File(xfile!.path);

                                        setState(() {
                                          _color = Colors.green;
                                        });
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'Choose From Camera',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  ]),
                                );
                              });
                        },
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        child: _color == Colors.red
                            ? Text('choose Photo')
                            : Text('Photo Selected'),
                        color: _color,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          await editNotes();
                        },
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        child: Text('Save'),
                        color: Colors.red,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
        ));
  }
}
