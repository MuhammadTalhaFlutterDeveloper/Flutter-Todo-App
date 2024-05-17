import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/home.dart';
import 'package:notes_app/model/notes_model.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  //this line of code will create path in your local storage
  var directory = await getApplicationDocumentsDirectory();
  //this line of code will create file in your assigned phone directory by using hive db
  //it will initialize the hive database
  Hive.init(directory.path);

  //we are registering notesAdapter
  Hive.registerAdapter(NotesModelAdapter());
  //we are creating a file through a notesModel
  await Hive.openBox<NotesModel>("notes");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.purple,
        ),
        home: const HomeScreen());
  }
}
