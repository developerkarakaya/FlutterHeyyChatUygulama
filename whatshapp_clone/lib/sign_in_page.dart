import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:whatshapp_clone/kayit_ol.dart';
import 'package:whatshapp_clone/viewModels/sign_in_view.dart';
import 'package:whatshapp_clone/whatshapp_main.dart';

class SignPage extends StatefulWidget {
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final TextEditingController _editingController = TextEditingController();
  final TextEditingController _editingController2 = TextEditingController();
  final TextEditingController _editingController3 = TextEditingController();

  var _userName;
  var _adsoyad;
  var _userPass;

  var _success;

  var _userId;

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog(String message) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Bilgi '),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> KayitOl() async {
      if (_editingController.text == "" ||
          _editingController2.text == "" ||
          _editingController3.text == "") {
        String message = "Lütfen E-Posta,Ad-Soyad veya Şifreyi Doğru Giriniz.";
        await _showMyDialog(message);
      }
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _editingController.text,
              password: _editingController2.text)
          .then((kullanici) {
        FirebaseFirestore.instance
            .collection('/users')
            .doc(_editingController.text)
            .set({
          'AdSoyad': _editingController3.text,
          'userName': _editingController.text,
          'password': _editingController2.text
        }).whenComplete(() {
          String message =
              _editingController.text + " Kişi Heyy! Uygulamasına Kaydedildi.";
          return _showMyDialog(message);
        });
      });
      _editingController.text = '';
      _editingController2.text = '';
    }

    Future<void> girisYap() async {
      final User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _editingController.text,
        password: _editingController2.text,
      ))
          .user;

      if (user != null) {
        setState(() {
          _success = true;
          _userName = user.email;
          _userId = user.uid;
        });
      } else {
        _success = false;
      }

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _editingController.text,
              password: _editingController2.text)
          .then((kullanici) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => WhatShappMain(
                      userAdSoyad: _adsoyad,
                      userName: _userName,
                      userId: _userId,
                    )),
            (Route<dynamic> route) => false);
      });
    }

    return ChangeNotifierProvider(
      create: (BuildContext context) => GetIt.instance<SignInModel>(),
      child: Consumer<SignInModel>(
        builder: (BuildContext context, SignInModel model, Widget child) =>
            Scaffold(
          appBar: AppBar(
            title: Text("Heyy ! Giriş Yap"),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 5),
                TextField(
                  maxLength: 50,
                  cursorColor: Theme.of(context).primaryColor,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.mark_email_unread_sharp,
                      color: Theme.of(context).primaryColor,
                    ),
                    contentPadding: EdgeInsets.all(4),
                    hintText: 'E-Posta ',
                  ),
                  controller: _editingController,
                ),
                SizedBox(height: 5),
                TextField(
                  obscureText: true,
                  maxLength: 12,
                  cursorColor: Theme.of(context).primaryColor,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,
                    ),
                    contentPadding: EdgeInsets.all(4),
                    hintText: 'Şifre',
                  ),
                  controller: _editingController2,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: RaisedButton(
                          child: Text(
                            'Kayıt Ol',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KayitOlMain(),
                                ));
                          }),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: RaisedButton(
                        child: Text(
                          'Giriş Yap',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        onPressed: girisYap,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Şifreni Mi Unuttun ? ',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
