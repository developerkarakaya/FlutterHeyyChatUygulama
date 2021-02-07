import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatshapp_clone/loginscreen.dart';

class SignUpScreen extends StatelessWidget {
  TextEditingController epostaController = TextEditingController();
  TextEditingController adsoyadController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController avatarController = TextEditingController();
  TextEditingController durumController = TextEditingController();
  TextEditingController telController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Future<void> _myDialog(String message) async {
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
      if (epostaController.text == "" ||
          adsoyadController.text == "" ||
          passwordController.text == "") {
        String message = "Lütfen E-Posta,Ad-Soyad veya Şifreyi Doğru Giriniz.";
        await _myDialog(message);
      }
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: epostaController.text, password: passwordController.text)
          .then((kullanici) {
        FirebaseFirestore.instance
            .collection('/users')
            .doc(epostaController.text)
            .set({
          'AdSoyad': adsoyadController.text,
          'userName': epostaController.text,
          'password': passwordController.text,
          'tel': telController.text,
          'avatar':
              'https://whatsappgrupbul.com/wp-content/plugins/all-in-one-seo-pack/images/default-user-image.png',
          'durum': durumController.text,
          'userId': kullanici.user.uid
        }).whenComplete(() {
          String message = " Kişi Heyy! Uygulamasına Kaydedildi.";
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Loginscreen()));
          return _myDialog(message);
        });
      });
      epostaController.text = '';
      adsoyadController.text = '';
      passwordController.text = '';
      telController.text = '';
      avatarController.text = '';
      durumController.text = '';
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
                height: 50,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    'Hesap Oluşturun',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35),
                  ),
                ],
              ),
              Container(
                child: Scrollbar(
                  controller: _scrollController,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        controllerMain: adsoyadController,
                        hint: '    Ad Soyad Gir',
                        issecured: false,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controllerMain: epostaController,
                        hint: '    E-Mail Gir',
                        issecured: false,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controllerMain: durumController,
                        hint: '    Durum Gir',
                        issecured: false,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controllerMain: telController,
                        hint: '    Telefon Gir',
                        issecured: false,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controllerMain: passwordController,
                        hint: '    Şifre Gir',
                        issecured: true,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: ButtonTheme(
                    buttonColor: Colors.white,
                    minWidth: MediaQuery.of(context).size.width,
                    height: 55,
                    child: RaisedButton(
                      onPressed: () {
                        KayitOl();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Loginscreen()));
                      },
                      child: Text(
                        'Oluştur',
                        style: TextStyle(color: Colors.grey, fontSize: 22),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
