import 'package:hive/hive.dart';
import 'package:notes_app/model/notes_model.dart';

class BoxClass {
  static Box<NotesModel> getData() {
    return Hive.box<NotesModel>('notes');
  }
}
