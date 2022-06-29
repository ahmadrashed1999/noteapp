import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noteappusingapi/app/componets/cardnotes.dart';
import 'package:noteappusingapi/app/componets/curd.dart';
import 'package:noteappusingapi/app/constant/linkapi.dart';
import 'package:noteappusingapi/model/notemodel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:swipe_to/swipe_to.dart';

import '../main.dart';
import 'notes/edit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _cont = ScrollController();
  RefreshController controller = RefreshController();
  scrol() {
    _cont.animateTo(0,
        duration: Duration(milliseconds: 700), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    Curd _curd = Curd();
    getNotes() async {
      var response =
          await _curd.postrequest(linkView, {'id': prefs.getString('id')});

      return response;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                prefs.clear();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('add');
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: ListView(children: [
          FutureBuilder(
            future: getNotes(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data['status'] == 'failed') {
                  return Center(child: Text('لا يوجد ملاحظات'));
                } else {
                  return ListView.builder(
                    controller: _cont,
                    physics: NeverScrollableScrollPhysics(),
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: snapshot.data['data'].length,
                    itemBuilder: (context, i) {
                      return SwipeTo(
                        animationDuration: Duration(milliseconds: 400),
                        iconOnLeftSwipe: Icons.edit,
                        iconColor: Colors.blue,
                        iconOnRightSwipe: Icons.delete,
                        onLeftSwipe: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return EditNote(
                              note: snapshot.data['data'][i],
                            );
                          }));
                        },
                        onRightSwipe: () async {
                          var response = await _curd.postrequest(linkDelete, {
                            'id':
                                snapshot.data['data'][i]['notes_id'].toString(),
                            'image': snapshot.data['data'][i]['notes_image']
                                .toString()
                          });
                          if (response['status'] == 'success') {
                            getNotes();
                            setState(() {});
                          }
                          setState(() {});
                        },
                        child: CardNotes(
                          noteModel:
                              NoteModel.fromJson(snapshot.data['data'][i]),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return EditNote(
                                note: snapshot.data['data'][i],
                              );
                            }));
                          },
                        ),
                      );
                    },
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return Center(child: Text('No Data'));
            },
          ),
        ]),
      ),
    );
  }
}
