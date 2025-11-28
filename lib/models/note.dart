class Note {
  final String text;
  final bool completed;

  Note({required this.text, this.completed = false});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'completed': completed,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      text: map['text'],
      completed: map['completed'] ?? false,
    );
  }
}