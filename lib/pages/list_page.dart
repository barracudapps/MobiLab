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

  @override
  Widget build(BuildContext context) {
    if(!isListLoaded) {
      ListManager().getTiles().then((loadedList) => setState(() => isListLoaded = true));
    }

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
              itemBuilder: (BuildContext context, index) => MyListTile(title: itemsList[index]['title'], content: itemsList[index]['content'], index: index+1, id: itemsList[index]['id']),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ///TODO Add dialog to fill that calls the adding function available in the list manager
          setState(() => isListLoaded = false);
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
