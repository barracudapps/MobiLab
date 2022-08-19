import 'package:flutter_test/flutter_test.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group("Testing list management", () {
    final instance = FakeFirebaseFirestore();

    const String title = "Title";
    const String content = "Content";
    String id = DateTime.now().toString();
    Map<String, dynamic> item = {
      "title": title,
      "content": content,
      "favorite": false,
    };

    List<dynamic> itemsList = [];

    /// Functions of lib/tools/list_manager.dart

    Future<void> getTiles() async {
      itemsList.clear();
      try {
        instance
            .collection("items")
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            for (var item in value.docs) {
              itemsList.add({
                "title": item["title"],
                "content": item["content"],
                "favorite": item["favorite"],
                "id": item.id,
              });
            }
          }
        });
        Future.delayed(Duration.zero);
      }catch(error){
        print(error);
      }
    }
    Future<void> addTile(String id, String title, String content) async {
      instance.runTransaction((transaction) async{
        transaction.set(instance
            .collection("items")
            .doc(id),
            {
              "title": item["title"],
              "content": item["content"],
              "favorite": false,
            });
      });
      getTiles();
    }
    Future<void> deleteTile(String id) async {
      instance.runTransaction((transaction) async{
        transaction.delete(instance
            .collection("items")
            .doc(id));
      });
      getTiles();
    }
    Future<void> clearTiles() async {
      for(int i = 0; i < itemsList.length; i ++){
        await deleteTile(itemsList[i]["id"]);
      }
      getTiles();
    }
    Future<void> setFavorite(String id, bool fav) async {
      instance.runTransaction((transaction) async{
        transaction.update(instance
            .collection("items")
            .doc(id),
            {
              "favorite": !fav,
            });
        Future.delayed(Duration.zero);
      });
      getTiles();
    }

    /// Testing

    test("Item should be added", () async{
      await addTile(id, item["title"], item["content"]);
      expect(itemsList.length, 1);
      expect(itemsList[0]["title"], title);
      expect(itemsList[0]["content"], content);
    });

    test("Item should be set as favorite", () async{
      await addTile(id, item["title"], item["content"]);
      print(itemsList);
      await setFavorite(id, itemsList[0]["favorite"]);
      print(itemsList);
      expect(itemsList[0]["favorite"], true);
    });

    test("List should be cleared", () async{
      await addTile(id, item["title"], item["content"]);
      itemsList.clear();
      expect(itemsList.isEmpty, true);
    });

    test("List should get 1 element", () async{
      await addTile(id, item["title"], item["content"]);
      itemsList.clear();
      await getTiles();
      expect(itemsList.length, 1);
    });

    test("Item should be deleted", () async{
      await addTile(id, item["title"], item["content"]);
      await addTile(DateTime.now().toString(), item["title"], item["content"]);
      await deleteTile(id);
      expect(itemsList.length, 1);
    });

    test("List should be empty", () async{
      await addTile(id, item["title"], item["content"]);
      await addTile(DateTime.now().toString(), item["title"], item["content"]);
      await clearTiles();
      expect(itemsList.isEmpty, true);
    });
  });
}