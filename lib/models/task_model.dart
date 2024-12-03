class Task {
  int? id;
  String name;
  String description;
  String dueDate;
  bool isCompleted;

  Task({
    this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      dueDate: map['dueDate'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}