/// Immutable task entity used across persistence and presentation layers.
class Task {
  const Task({
    required this.id,
    required this.title,
    this.note,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String? note;
  final bool isCompleted;

  Task copyWith({
    String? id,
    String? title,
    String? note,
    bool? isCompleted,
    bool clearNote = false,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      note: clearNote ? null : note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'note': note, 'isCompleted': isCompleted};
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      note: json['note'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Task &&
            other.id == id &&
            other.title == title &&
            other.note == note &&
            other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => Object.hash(id, title, note, isCompleted);
}
