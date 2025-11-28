import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/notes_cubit.dart';
import '../models/note.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Notes",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          // Input Section with beautiful design
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Add a new note...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Clean Circular Add Button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue[500],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white, size: 20),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        context.read<NotesCubit>().addNote(controller.text);
                        controller.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<NotesCubit, List<Note>>(
              builder: (context, notes) {
                if (notes.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_add_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No notes yet",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Add your first note above!",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: notes.length,
                  itemBuilder: (_, index) {
                    final note = notes[index];
                    return _buildNoteCard(context, note, index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          decoration: BoxDecoration(
            color: note.completed ? Colors.green[50] : Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: note.completed ? Colors.green[200]! : Colors.grey[300]!,
            ),
          ),
          child: Checkbox(
            value: note.completed,
            onChanged: (_) => context.read<NotesCubit>().toggleComplete(index),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.green[400]!;
              }
              return Colors.transparent;
            }),
          ),
        ),
        title: Text(
          note.text,
          style: TextStyle(
            fontSize: 16,
            decoration: note.completed ? TextDecoration.lineThrough : TextDecoration.none,
            color: note.completed ? Colors.grey : Colors.black87,
            fontWeight: note.completed ? FontWeight.normal : FontWeight.w500,
          ),
        ),
        // Simple delete button
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.grey[500], size: 20),
          onPressed: () => context.read<NotesCubit>().deleteNote(index),
        ),
      ),
    );
  }
}