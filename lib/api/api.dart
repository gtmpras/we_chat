import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat/models/chat_user_models.dart';
import 'dart:developer';

import 'package:we_chat/models/message_model.dart';

class APIs {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for storing self information
  static late ChatUserModel me;

  //to return current user
  static User get user => auth.currentUser!;

  //for accessing firebase messaging (Push notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  //for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push Token: $t');
      }
    });
  }

  //for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user)async {
          if (user.exists)
            {
              me = ChatUserModel.fromJson(user.data()!);
            await  getFirebaseMessagingToken();
              //for setting user status to active
              APIs.updateActiveStatus(true);
              log('My Data:  ${user.data()}');
            }
          else
            {createUser().then((value) => getSelfInfo());}
        });
  }

  //for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUserModel(
        image: user.photoURL.toString(),
        about: "Hey, we are using We Chat",
        name: user.displayName.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        id: user.uid,
        pushToken: '',
        email: user.email.toString());

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

//for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    //for showing the id of remaining users instead of user's own's id
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //for updating user information
  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'name': me.name, 'about': me.about});
  }

  //update profile picture
  static Future<void> updateProfilePicture(File file) async {
    //file extensions
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with  path
    final ref = storage.ref().child('profile_picture/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000}kb');
    });

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  //useful for getting conversation id
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUserModel chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  //update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  /*************Chat Screen Related APIs*********** */
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUserModel user) {
    //for getting all messages of a specific conversation from firestore database
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  //for sending message
  static Future<void> sendMessage(
      ChatUserModel chatUser, String msg, Type type) async {
//message sending time also used as ID
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    //message to send
    final MessageModel messagae = MessageModel(
        msg: msg,
        toId: user.uid,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);
    final ref = firestore
        .collection('chats/${getConversationId(chatUser.id)}/messages/');
    ref.doc().set(messagae.toJson());
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(MessageModel message) async {
    firestore
        .collection('chats/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUserModel user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chat image
  static Future<void> sendChatImage(ChatUserModel chatUser, File file) async {
    final ext = file.path.split('.').last;

    //storage file ref with  path
    final ref = storage.ref().child(
        'images/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000}kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }
}
