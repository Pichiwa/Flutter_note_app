import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/note.dart';
import '../repository/notes_repository.dart';

class NotesCubit extends Cubit<List<Note>> {
  final NotesRepository _repository;

  NotesCubit(this._repository) : super([]) {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await _repository.loadNotes();
      emit(notes);
    } catch (e) {
      print('Error loading notes in cubit: $e');
      emit([]);
    }
  }

  void addNote(String text) async {
    try {
      if (text.trim().isEmpty) return;
      
      final newNote = Note(text: text.trim());
      final newNotes = [...state, newNote];
      
      final success = await _repository.saveNotes(newNotes);
      if (success) {
        emit(newNotes);
      }
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  void toggleComplete(int index) async {
    try {
      if (index < 0 || index >= state.length) return;
      
      final newNotes = state.toList();
      newNotes[index] = Note(
        text: newNotes[index].text,
        completed: !newNotes[index].completed,
      );
      
      final success = await _repository.saveNotes(newNotes);
      if (success) {
        emit(newNotes);
      }
    } catch (e) {
      print('Error toggling note: $e');
    }
  }

  void deleteNote(int index) async {
    try {
      if (index < 0 || index >= state.length) return;
      
      final newNotes = state.toList();
      newNotes.removeAt(index);
      
      final success = await _repository.saveNotes(newNotes);
      if (success) {
        emit(newNotes);
      }
    } catch (e) {
      print('Error deleting note: $e');
    }
  }
}