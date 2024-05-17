import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/boxes/boxes.dart';
import 'package:notes_app/model/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 84, 34),
        centerTitle: true,
        title: const Text(
          "Todo App",
        ),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: BoxClass.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Text(data[index].title.toString()),
                  subtitle: Text(data[index].description.toString()),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            _editDialog(
                                data[index],
                                data[index].title.toString(),
                                data[index].description.toString());
                          },
                          child: const Icon(Icons.edit)),
                      GestureDetector(
                          onTap: () {
                            delete(data[index]);
                          },
                          child: const Icon(Icons.delete)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showDialog();
          //it means that create a box/file with Talha name
          //   var box = await Hive.openBox("Talha");
          //   var box2 = await Hive.openBox("box2");
          //   box2.put("MyDetails", {
          //     'name': "M.Talha",
          //     "gender": "Male",
          //     "age": 24,
          //     "Id": 3242423,
          //   });
          //   box2.put("youtube", "Freelancer Talha");
          //   box.put("name", "Muhammad Talha");
          //   box.put("age", 24);
          //   box2.put("gender", "Male");

          //   print(box2.get("MyDetails")['Id']);
          //   print(box2.get("youtube"));
          //   print(box2.get("gender"));
          //   print(box.get("name"));
          //   print(box.get("age"));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  //create future dialog
  Future<void> _showDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text("Add Notes")),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  style: const TextStyle(height: 0.9),
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: const TextStyle(height: 0.9),
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  titleController.clear();
                  descriptionController.clear();
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  final data = NotesModel(
                      title: titleController.text,
                      description: descriptionController.text);
                  final box = BoxClass.getData();
                  box.add(data);

                  titleController.clear();
                  descriptionController.clear();
                  print(box);
                  Navigator.pop(context);
                },
                child: const Text("Add")),
          ],
        );
      },
    );
  }

  //create function to delete the data
  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  //create function for edit
  Future<void> _editDialog(
      NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text("Edit Task")),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  style: const TextStyle(height: 0.9),
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: const TextStyle(height: 0.9),
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  titleController.clear();
                  descriptionController.clear();
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  notesModel.title = titleController.text.toString();
                  notesModel.description =
                      descriptionController.text.toString();
                  notesModel.save();
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                },
                child: const Text("Edit")),
          ],
        );
      },
    );
  }
}
