import 'package:flutter/material.dart';

import '../tools/list_manager.dart';
import '../tools/models/tiles.dart';
import '../tools/utils/global_variables.dart';


class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool isListLoaded = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    ListManager().getTiles();
    super.initState();
  }

  void addDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              validator: (value) => value!.isEmpty ? "Write title": null,
              decoration: const InputDecoration(hintText: "Write title",),
              maxLength: 20,
            ),
            TextFormField(
              controller: _contentController,
              validator: (value) => value!.isEmpty ? "Write content": null,
              decoration: const InputDecoration(hintText: "Write content",),
              maxLength: 50,
            ),
          ],
        ),
      ),
      title: const Text('Add an item'),
      actions: <Widget>[
        InkWell(
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text('LEAVE'),
          ),
          onTap: () {
            Navigator.of(context).pop();
            _titleController.clear();
            _contentController.clear();
          },
        ),
        InkWell(
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text('ADD'),
          ),
          onTap: () {
            if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
              String id = DateTime.now().toString();
              ListManager().addTile(id, _titleController.text, _contentController.text);
              Navigator.of(context).pop();
              setState((){
                itemsList.add({
                  "title": _titleController.text,
                  "content": _contentController.text,
                  "favorite": false,
                  "id": id,
                });
                _titleController.clear();
                _contentController.clear();
              });
            }
          },
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    print(DateTime.now().toString());
    print(itemsList);

    return Scaffold(
      body: itemsList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text("No data found", style: TextStyle(fontSize: 24),),
                  SizedBox(height: 24,),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
              itemCount: itemsList.length,
              itemBuilder: (BuildContext context, index) => Dismissible(
                direction: DismissDirection.endToStart,
                key: ObjectKey(itemsList[index]['id']),
                onDismissed: (DismissDirection direction){
                  direction == DismissDirection.endToStart
                      ? setState((){
                        ListManager().deleteTile(itemsList[index]['id']);
                        itemsList.removeAt(index);
                      })
                      : null;
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete),
                ),
                child: GestureDetector(
                  onTap: () {
                    ListManager().setFavorite(itemsList[index]['id'], itemsList[index]['favorite']);
                    setState((){
                      itemsList[index]['favorite'] = !itemsList[index]['favorite'];
                    });
                  },
                  child: MyListTile(
                    title: itemsList[index]['title'],
                    content: itemsList[index]['content'],
                    index: index+1,
                    isFav: itemsList[index]['favorite'],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addDialog(context),
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
