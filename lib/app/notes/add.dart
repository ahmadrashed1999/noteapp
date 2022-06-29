import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteappusingapi/app/componets/curd.dart';

import '../../main.dart';
import '../componets/customtext.dart';
import '../componets/valid.dart';
import '../constant/linkapi.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> with Curd {
  File? Myfile;
  bool isloading = false;
  Color _color = Colors.red;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  addNotes() async {
    isloading = true;
    setState(() {});
    if (Myfile == null) {
      return AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error',
          desc: 'Please select image',
          btnOkOnPress: () {},
          btnOkIcon: Icons.close,
          btnOkColor: Colors.red)
        ..show();
    } else {
      var response = await postRequestWithFile(
          linkAdd,
          {
            'title': _titleController.text,
            'content': _descriptionController.text,
            'id': prefs.getString('id')
          },
          Myfile!);
      if (response['status'] == 'success') {
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } else {
        Navigator.of(context).pushNamed('add');
      }
      return response;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Note'),
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
                                        Myfile = File(xfile!.path);

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
                                        Myfile = File(xfile!.path);

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
                          if (_formKey.currentState!.validate()) {
                            await addNotes();
                          }
                        },
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        child: Text('Add'),
                        color: Colors.red,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
        ));
  }
}
