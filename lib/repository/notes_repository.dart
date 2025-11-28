import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/note.dart';

class NotesRepository {
  static const String _storageKey = 'notes_data';

  Future<List<Note>> loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesString = prefs.getString(_storageKey);
      
      if (notesString == null || notesString.isEmpty) {
        return [];
      }
      
      final List<dynamic> notesList = json.decode(notesString);
      return notesList.map((item) => Note.fromMap(item)).toList();
      
    } catch (e) {
      print('Error loading notes: $e');
      return [];
    }
  }

  Future<bool> saveNotes(List<Note> notes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = notes.map((note) => note.toMap()).toList();
      return await prefs.setString(_storageKey, json.encode(notesJson));
    } catch (e) {
      print('Error saving notes: $e');
      return false;
    }
  }
}