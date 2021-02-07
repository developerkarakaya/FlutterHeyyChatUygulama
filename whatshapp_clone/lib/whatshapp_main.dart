import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatshapp_clone/arama_page.dart';
import 'package:whatshapp_clone/camera_page.dart';
import 'package:whatshapp_clone/contacts.dart';
import 'package:whatshapp_clone/durum_page.dart';
import 'package:whatshapp_clone/loginscreen.dart';
import 'package:whatshapp_clone/sign_in_page.dart';
import 'package:whatshapp_clone/sohbet_page.dart';

class WhatShappMain extends StatefulWidget {
  String userName;
  String userId;
  String userAdSoyad;
  String userAvatar;
  WhatShappMain(
      {Key key, this.userName, this.userId, this.userAdSoyad, this.userAvatar})
      : super(key: key);

  @override
  _WhatShappMainState createState() => _WhatShappMainState();
}

class _WhatShappMainState extends State<WhatShappMain>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _showMessage = true;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      _showMessage = _tabController.index != 0;
      setState(() {});
    });
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.exit_to_app_rounded),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((user) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Loginscreen()),
                      (route) => false);
                });
              })
        ],
        title: Row(
          children: [
            Text('Heyy ! ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            Text(widget.userAdSoyad)
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.camera_alt),
            ),
            Tab(
              text: 'Mesajlar',
            ),
            Tab(
              text: 'Durumlar',
            ),
            Tab(
              text: 'Aramalar',
            ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: <Widget>[
        CameraPage(),
        SohbetPage(
          userId: widget.userId,
        ),
        DurumPage(),
        AramaPage()
      ]),
      floatingActionButton: _showMessage
          ? FloatingActionButton(
              child: Icon(
                Icons.message,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactsMain(
                              userAvatar: widget.userAvatar,
                              userAdSoyad: widget.userAdSoyad,
                              userId: widget.userId,
                            )));
              },
            )
          : null,
    );
  }
}

class GetUserName extends StatelessWidget {
  final String email;

  GetUserName(this.email);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(email).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("hata");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Text(data['AdSoyad']);
        }

        return Text('');
      },
    );
  }
}
