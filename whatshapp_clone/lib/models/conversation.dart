import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String id;
  String name;
  String profileImage;
  String displayMessage;

  Conversation({this.id, this.name, this.profileImage, this.displayMessage});

  factory Conversation.fromSnapshot(DocumentSnapshot snapshot) {
    return Conversation(
        id: snapshot.id,
        name: 'samet karakaau',
        profileImage: 'https://placekitten.com/200/300',
        displayMessage: 'Merhaba');
  }
}
