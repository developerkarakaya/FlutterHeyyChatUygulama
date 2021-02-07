import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:whatshapp_clone/sohbet_detay.dart';

class ContactsMain extends StatefulWidget {
  String userId;
  String userAdSoyad;
  String userAvatar;
  @override
  _ContactsMainState createState() => _ContactsMainState();
  ContactsMain({Key key, this.userId, this.userAdSoyad, this.userAvatar});
}

class _ContactsMainState extends State<ContactsMain> {
  // ignore: deprecated_member_use
  Future<void> chatBegin(String profileUserId, String adsoyad, String tel,
      String avatar, String durum, String password) async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    var ref = _db.collection('conversations');
    var documentRef = await ref.add({
      'displayMessage': '',
      'members': [widget.userId, profileUserId],
      'gondericiavatar': widget.userAvatar,
      'gondericiadsoyad': widget.userAdSoyad,
      'aliciavatar': avatar,
      'aliciadsoyad': adsoyad,
      'gondericiId': widget.userId,
      'aliciId': profileUserId
    });
    // ignore: deprecated_member_use
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SohbetDetay(
                  userAdSoyad: adsoyad,
                  userAvatar: avatar,
                  conversationId: documentRef.id,
                  userId: widget.userId,
                )));
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollcontroller = ScrollController();
    FirebaseFirestore _db = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Kişiler'),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: null),
          IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: null)
        ],
      ),
      body: StreamBuilder(
        stream: _db.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scrollbar(
            child: ListView(
              controller: _scrollcontroller,
              children: snapshot.data.docs.map((contact) {
                if (contact['userId'] != widget.userId) {
                  return Dismissible(
                    key: Key(contact['userId']),
                    onDismissed: (direction) {
                      CollectionReference _userRef = _db.collection('users');
                      _userRef.doc(contact.id).delete().then((value) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text(
                                '${contact["AdSoyad"]} Kişisi kişi listesinden silindi.')));
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            Text(
                              " Sil",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                    child: ListTile(
                      onTap: () => chatBegin(
                          contact['userId'],
                          contact['AdSoyad'],
                          contact['tel'],
                          contact['avatar'],
                          contact['durum'],
                          contact['password']),
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(contact['avatar'])),
                      title: Text(contact['AdSoyad']),
                      subtitle: Text(contact['tel']),
                      trailing: IconButton(
                          onPressed: () {
                            _callNumber(contact['tel']);
                          },
                          icon: Icon(Icons.phone)),
                    ),
                  );
                } else {
                  return Center();
                }
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  _basildi() {
    print("dedsfj");
  }
}

Future<void> _callNumber(String phoneNumber) async {
  await FlutterPhoneDirectCaller.callNumber(phoneNumber);
}
