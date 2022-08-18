import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'utils/global_variables.dart';

abstract class ListManagerImpl{
  Future<void> getTiles();
  Future<void> addTile(String id, String title, String content);
  Future<void> deleteTile(String id);
  Future<void> setFavorite(String id, bool fav);
}

class ListManager implements ListManagerImpl {
  @override
  Future<void> getTiles() async {
    itemsList.clear();
    FirebaseFirestore.instance
        .collection("items")
        .get()
        .then((value){
      if(value.docs.isNotEmpty){
        for(var item in value.docs) {
          itemsList.add({
            "title": item["title"],
            "content": item["content"],
            "favorite": item["favorite"],
            "id": item.id,
          });
        }
      }
    });
  }

  @override
  Future<void> addTile(String id, String title, String content) async {
    FirebaseFirestore.instance.runTransaction((transaction) async{
      transaction.set(FirebaseFirestore.instance
          .collection("items")
          .doc(id),
          {
            "title": title,
            "content": content,
            "favorite": false,
          });
    });
  }

  @override
  Future<void> deleteTile(String id) async {
    FirebaseFirestore.instance.runTransaction((transaction) async{
      transaction.delete(FirebaseFirestore.instance
          .collection("items")
          .doc(id));
    });
  }

  @override
  Future<void> setFavorite(String id, bool fav) async {
    FirebaseFirestore.instance.runTransaction((transaction) async{
      transaction.update(FirebaseFirestore.instance
          .collection("items")
          .doc(id),
          {
            "favorite": !fav,
          });
      Future.delayed(Duration.zero);
    });
  }
}