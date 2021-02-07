import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:whatshapp_clone/signupscreen.dart';
import 'package:whatshapp_clone/whatshapp_main.dart';

class Loginscreen extends StatefulWidget {
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _editingController = TextEditingController();

  final TextEditingController _editingController2 = TextEditingController();

  final TextEditingController _editingController3 = TextEditingController();

  var _userName;
  bool googlelogged = false;
  var _adsoyad;
  bool _showPassword = false;

  var _userPass;

  var _success;
  var _avatar;
  var _userId;

  @override
  Widget build(BuildContext context) {
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

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

    Future googleSignIn() async {
      try {
        await _googleSignIn.signIn();
        setState(() {
          googlelogged = true;
        });
      } catch (e) {
        print(e);
      }
    }

    Future<void> girisYap() async {
      final User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _editingController.text,
        password: _editingController2.text,
      ))
          .user;

      FirebaseFirestore _db = FirebaseFirestore.instance;

      var document =
          FirebaseFirestore.instance.collection('users').doc(user.email);

      document.get().then((girenuser) {
        setState(() {
          _adsoyad = girenuser['AdSoyad'];
          _avatar = girenuser['avatar'];
        });
      });

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
                      userAvatar: _avatar,
                      userAdSoyad: _adsoyad,
                      userName: _userName,
                      userId: _userId,
                    )),
            (Route<dynamic> route) => false);
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/1.png'), fit: BoxFit.cover),
          gradient: LinearGradient(
              colors: [Colors.blue[400], Colors.blue],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 180,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    'Heyy !',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    'Giriş yapmak için hesap oluşturun',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                ],
              ),
              SizedBox(
                height: 65,
              ),
              CustomTextField(
                controllerMain: _editingController,
                issecured: false,
                hint: '    E-Mail',
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: _editingController2,
                    obscureText: !this._showPassword,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          color: this._showPassword ? Colors.grey : Colors.blue,
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              this._showPassword = !this._showPassword;
                            });
                          },
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        hintText: '   Şifre',
                        hintStyle: TextStyle(
                            fontSize: 18,
                            letterSpacing: 1.5,
                            color: Colors.white70,
                            fontWeight: FontWeight.w900),
                        filled: true,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        fillColor: Colors.white.withOpacity(.3),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(25),
                        )),
                  )),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: 40,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: ButtonTheme(
                    buttonColor: Colors.white,
                    minWidth: MediaQuery.of(context).size.width,
                    height: 55,
                    child: RaisedButton(
                      onPressed: girisYap,
                      child: Text(
                        'Giriş Yap',
                        style: TextStyle(color: Colors.grey, fontSize: 22),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    )),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Hesabınız yok mu ?",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => SignUpScreen()));
                    },
                    child: Text(
                      'Kaydol',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  String hint;
  bool issecured;
  final TextEditingController controllerMain;
  CustomTextField({this.hint, this.issecured, this.controllerMain});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextField(
          controller: controllerMain,
          obscureText: issecured,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(25),
              ),
              hintText: hint,
              hintStyle: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1.5,
                  color: Colors.white70,
                  fontWeight: FontWeight.w900),
              filled: true,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              fillColor: Colors.white.withOpacity(.3),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(25),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(25),
              )),
        ));
  }
}
