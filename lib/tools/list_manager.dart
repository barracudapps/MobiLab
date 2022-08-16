import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'utils/global_variables.dart';

abstract class ListManagerImpl{
  Future<void> getTiles();
  Future<void> addTile(String title, String content);
  Future<void> deleteTile(String id);
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
            "id": item.id,
          });
        }
      }
    });
  }

  @override
  Future<void> addTile(String title, String content) async {
    FirebaseFirestore.instance.runTransaction((transaction) async{
      transaction.set(FirebaseFirestore.instance
          .collection("items")
          .doc(itemsList[itemsList.length]),
          {
            "title": title,
            "content": content,
          });
    });
  }

  @override
  Future<void> deleteTile(String id) async {
    ///TODO Implement
  }
}