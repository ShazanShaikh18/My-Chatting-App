import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/chat_user_model.dart';

class APIs {

  static final user = FirebaseAuth.instance.currentUser!;
  
  static Future<bool> userExists() async {
    return (await FirebaseFirestore.instance.collection('users').doc(user.uid).get()).exists;
  }

  static Future<void> createUser() async{
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: 'Hey! I am a new user.',
      image: user.photoURL.toString(),
      createdAt: time,
      lastActive: time,
      isOnline: false,
      pushToken: '',
      );

      return await FirebaseFirestore.instance.collection('users').doc(user.uid).set(chatUser.toJson());
  }
}