import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class SohbetDetay extends StatefulWidget {
  String userId;
  String conversationId;
  String userAdSoyad;
  String userAvatar;
  SohbetDetay(
      {Key key,
      this.userId,
      this.conversationId,
      this.userAdSoyad,
      this.userAvatar})
      : super(key: key);

  @override
  _SohbetDetayState createState() => _SohbetDetayState();
}

class _SohbetDetayState extends State<SohbetDetay> {
  final TextEditingController _editingController = TextEditingController();
  CollectionReference _ref;
  FocusNode _focusNode;
  ScrollController _scrollController;
  @override
  void initState() {
    _focusNode = FocusNode();
    _scrollController = ScrollController();

    _ref = FirebaseFirestore.instance
        .collection('/conversations/${widget.conversationId}/messages');

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -10,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userAvatar),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(widget.userAdSoyad),
            )
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(4.0),
            child: InkWell(
              child: Icon(Icons.phone),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: InkWell(
              child: Icon(Icons.camera_alt),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: InkWell(
              child: Icon(Icons.more_vert),
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage('https://placekitten.com/600/800'),
        )),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _focusNode.unfocus(),
                child: StreamBuilder(
                    stream: _ref.orderBy('time').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return !snapshot.hasData
                          ? CircularProgressIndicator()
                          : ListView(
                              controller: _scrollController,
                              children: snapshot.data.docs
                                  .map<Widget>((document) => ListTile(
                                        title: Align(
                                          alignment: widget.userId !=
                                                  document['senderId']
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                          child: widget.userId !=
                                                  document['senderId']
                                              ? Container(
                                                  padding: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius
                                                              .horizontal(
                                                                  left: Radius
                                                                      .circular(
                                                                          10),
                                                                  right: Radius
                                                                      .circular(
                                                                          10)),
                                                      color: Colors.white),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        document['message'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4),
                                                        child: Text(
                                                          new DateFormat.Hm()
                                                              .format(DateTime
                                                                  .fromMillisecondsSinceEpoch(
                                                                      document[
                                                                              'time']
                                                                          .millisecondsSinceEpoch)),
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  padding: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.horizontal(
                                                            left:
                                                                Radius.circular(
                                                                    10),
                                                            right:
                                                                Radius.circular(
                                                                    10)),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        document['message'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4),
                                                        child: Text(
                                                          new DateFormat.Hm()
                                                              .format(DateTime
                                                                  .fromMillisecondsSinceEpoch(
                                                                      document[
                                                                              'time']
                                                                          .millisecondsSinceEpoch)),
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ),
                                      ))
                                  .toList());
                    }),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(25),
                          right: Radius.circular(25))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          child: Icon(
                            Icons.tag_faces,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 1),
                          child: TextField(
                            focusNode: _focusNode,
                            controller: _editingController,
                            decoration: InputDecoration(
                                hintText: 'Bir mesaj yazın',
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          child: Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 1),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor),
                  child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        if (_editingController.text != '') {
                          _ref.add({
                            'senderId': widget.userId,
                            'message': _editingController.text,
                            'time': DateTime.now()
                          });
                          _editingController.text = '';
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(microseconds: 200),
                              curve: Curves.easeIn);
                        }
                      }),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
