import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'habit.dart';
import 'package:uuid/uuid.dart';

class HabitModel extends ChangeNotifier {
  final List<Habit> _habits = [];
  final _uuid = const Uuid();

  List<Habit> get habits => List.unmodifiable(_habits);

  void addHabit(String title, int freq) {
    final habit = Habit(id: _uuid.v4(), title: title, frequencyPerWeek: freq);
    _habits.add(habit);
    saveToPrefs();
    notifyListeners();
  }

  void toggleCompleted(String id) {
    final idx = _habits.indexWhere((h) => h.id == id);
    if (idx != -1) {
      _habits[idx].completedToday = !_habits[idx].completedToday;
      saveToPrefs();
      notifyListeners();
    }
  }

  void deleteHabit(String id) {
    _habits.removeWhere((h) => h.id == id);
    saveToPrefs();
    notifyListeners();
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_habits.map((h) => h.toJson()).toList());
    await prefs.setString('habits', encoded);
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('habits');
    if (data != null) {
      final list = (jsonDecode(data) as List<dynamic>)
          .map((e) => Habit.fromJson(e as Map<String, dynamic>))
          .toList();
      _habits.clear();
      _habits.addAll(list);
      notifyListeners();
    }
  }
}