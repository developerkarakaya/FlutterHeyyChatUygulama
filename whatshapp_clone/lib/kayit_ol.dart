import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatshapp_clone/sign_in_page.dart';

class KayitOlMain extends StatelessWidget {
  TextEditingController epostaController = TextEditingController();
  TextEditingController adsoyadController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController avatarController = TextEditingController();
  TextEditingController durumController = TextEditingController();
  TextEditingController telController = TextEditingController();

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
              context, MaterialPageRoute(builder: (context) => SignPage()));
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
      appBar: AppBar(
        title: Text('Heyy ! Kayıt Ol'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
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
              controller: epostaController,
            ),
            TextField(
              maxLength: 50,
              cursorColor: Theme.of(context).primaryColor,
              style: TextStyle(color: Theme.of(context).primaryColor),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.account_circle,
                  color: Theme.of(context).primaryColor,
                ),
                contentPadding: EdgeInsets.all(4),
                hintText: 'Ad Soyad',
              ),
              controller: adsoyadController,
            ),
            TextField(
              maxLength: 11,
              cursorColor: Theme.of(context).primaryColor,
              style: TextStyle(color: Theme.of(context).primaryColor),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.phone,
                  color: Theme.of(context).primaryColor,
                ),
                contentPadding: EdgeInsets.all(4),
                hintText: 'Telefon',
              ),
              controller: telController,
            ),
            TextField(
              maxLength: 200,
              cursorColor: Theme.of(context).primaryColor,
              style: TextStyle(color: Theme.of(context).primaryColor),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.message,
                  color: Theme.of(context).primaryColor,
                ),
                contentPadding: EdgeInsets.all(4),
                hintText: 'Durum Yazısı',
              ),
              controller: durumController,
            ),
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
              controller: passwordController,
            ),
            RaisedButton(
              child: Text(
                'Kayıt Ol',
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              onPressed: KayitOl,
            )
          ],
        ),
      ),
    );
  }
}
