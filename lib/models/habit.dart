class Habit {
  String id;
  String title;
  int frequencyPerWeek;
  bool completedToday;

  Habit({
    required this.id,
    required this.title,
    this.frequencyPerWeek = 1,
    this.completedToday = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'frequencyPerWeek': frequencyPerWeek,
        'completedToday': completedToday,
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'],
        title: json['title'],
        frequencyPerWeek: json['frequencyPerWeek'] ?? 1,
        completedToday: json['completedToday'] ?? false,
      );
}