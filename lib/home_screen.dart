import 'package:flutter/material.dart';
import 'package:hive_database/models/notes_model.dart';
import 'package:hive_flutter/adapters.dart';
import 'boxes/boxes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          if (data.isEmpty) {
            return const Center(
              child: Card(
                color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "No data",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                            data[index].title.toString(),
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            deleteNotes(data[index]);
                          },
                          child: const Icon(
                              Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 15),
                        InkWell(
                          onTap: () {
                            _editMyDialog(data[index],data[index].title.toString() , data[index].description.toString());
                          },
                          child: const Icon(Icons.edit),
                        )
                      ],
                    ),
                    Text(
                        data[index].description.toString(),
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },
        child: const Icon(
          Icons.add
        ),
      ),
    );
  }

  Future deleteNotes(NotesModel notesModel) async{
    await notesModel.delete();
  }

  Future<void> _editMyDialog(NotesModel notesModel, String title, String description) async{
    titleController.text = title;
    descriptionController.text = description;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Title',
                        border: OutlineInputBorder()
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Description',
                        border: OutlineInputBorder()
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),

              TextButton(
                onPressed: () {
                  notesModel.title = titleController.text.toString();
                  notesModel.description = descriptionController.text.toString();
                  notesModel.save();
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Edit'),
              ),
            ],
          );
        }
    );
  }

  Future<void> _showMyDialog() async{
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Notes'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Title',
                    border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Description',
                    border: OutlineInputBorder()
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                final data = NotesModel(title: titleController.text,
                    description: descriptionController.text);
                final box = Boxes.getData();
                box.add(data);
                // data.save();
                titleController.clear();
                descriptionController.clear();
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      }
    );
  }

}
