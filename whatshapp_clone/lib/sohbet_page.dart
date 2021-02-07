import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatshapp_clone/models/conversation.dart';
import 'package:whatshapp_clone/sohbet_detay.dart';
import 'package:whatshapp_clone/viewModels/chart_model.dart';

class SohbetPage extends StatefulWidget {
  String userId;
  @override
  _SohbetPageState createState() => _SohbetPageState();

  SohbetPage({Key key, this.userId}) : super(key: key);
}

class _SohbetPageState extends State<SohbetPage> {
  var model = GetIt.instance<ChartModel>();

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // RRCyIWmYOzWAnXoGH5xFIcXRFjo2
    final String userId = widget.userId;
    return ChangeNotifierProvider(
      create: (BuildContext context) => model,
      child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('conversations')
              .where('members', arrayContains: userId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error : ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data.docs.map<Widget>((doc) {
                if (widget.userId == doc['gondericiId']) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SohbetDetay(
                                          userAdSoyad:
                                              doc['aliciadsoyad'] != null
                                                  ? doc['aliciadsoyad']
                                                  : '',
                                          userAvatar: doc['aliciavatar'] != null
                                              ? doc['aliciavatar']
                                              : '',
                                          userId: userId,
                                          conversationId: doc.id,
                                        )));
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(doc['aliciavatar'] !=
                                    null
                                ? doc['aliciavatar']
                                : 'https://www.mobiluygulama.com.tr/wp-content/plugins/all-in-one-seo-pack/images/default-user-image.png'),
                          ),
                          title: Text(doc['aliciadsoyad'] != null
                              ? doc['aliciadsoyad']
                              : ''),
                          subtitle: GetMessage(doc.id) != null
                              ? GetMessage(doc.id)
                              : Text('Mesajlaşma Yok'),
                          trailing: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  new DateFormat.MMMEd()
                                      .format(new DateTime.now()),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => SohbetDetay(
                                          userAdSoyad:
                                              doc['gondericiadsoyad'] != null
                                                  ? doc['gondericiadsoyad']
                                                  : '',
                                          userAvatar:
                                              doc['gondericiavatar'] != null
                                                  ? doc['gondericiavatar']
                                                  : '',
                                          userId: userId,
                                          conversationId: doc.id,
                                        )));
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(doc[
                                        'gondericiavatar'] !=
                                    null
                                ? doc['gondericiavatar']
                                : 'https://www.mobiluygulama.com.tr/wp-content/plugins/all-in-one-seo-pack/images/default-user-image.png'),
                          ),
                          title: Text(doc['gondericiadsoyad'] != null
                              ? doc['gondericiadsoyad']
                              : ''),
                          subtitle: GetMessage(doc.id) != null
                              ? GetMessage(doc.id)
                              : Text('Mesajlaşma Yok'),
                          trailing: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  new DateFormat.MMMEd()
                                      .format(new DateTime.now()),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }).toList(),
            );
          }),
    );
  }

  // String documentDisplayMessage(String id) {
  //   FirebaseFirestore _db = FirebaseFirestore.instance;

  //   var document = FirebaseFirestore.instance
  //       .collection('/conversations/' + id + '/messages');

  //   document.get().then((data) {
  //     print(data.docs[0]['message']);
  //     return "${data.docs[0]['message']}";
  //   });
  // }
}

class GetMessage extends StatelessWidget {
  String id;

  GetMessage(this.id);

  @override
  Widget build(BuildContext context) {
    CollectionReference messages = FirebaseFirestore.instance
        .collection('/conversations/' + id + '/messages');
    return FutureBuilder<QuerySnapshot>(
      future: messages.orderBy('time', descending: true).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("hata");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Text(snapshot.data.docs[0]['message']);
        }

        return Center(
          child: Text(''),
        );
      },
    );
  }
}
