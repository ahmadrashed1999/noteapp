import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noteappusingapi/app/constant/linkapi.dart';
import 'package:noteappusingapi/model/notemodel.dart';

class CardNotes extends StatelessWidget {
  final NoteModel noteModel;
  final void Function() onTap;
  CardNotes({Key? key, required this.noteModel, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Image.network(
              '$linkImageRoot${noteModel.notesImage}',
              width: 100,
              height: 100,
              fit: BoxFit.fill,
            )),
            Expanded(
                flex: 2,
                child: ListTile(
                  title: Text('${noteModel.notesTitle}'),
                  subtitle: Text('${noteModel.notesContent}'),
                )),
          ],
        ),
      ),
    );
  }
}
