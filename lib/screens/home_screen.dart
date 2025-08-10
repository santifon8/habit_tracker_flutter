import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit_model.dart';
import '../models/habit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _freqCtrl = TextEditingController(text: '1');

  @override
  void dispose() {
    _titleCtrl.dispose();
    _freqCtrl.dispose();
    super.dispose();
  }

  void _showCreateDialog(HabitModel model) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Crear nuevo hábito'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Título')),
            TextField(controller: _freqCtrl, decoration: const InputDecoration(labelText: 'Frecuencia por semana'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () { Navigator.of(context).pop(); }, child: const Text('Cancelar')),
          ElevatedButton(onPressed: () {
            final title = _titleCtrl.text.trim();
            final freq = int.tryParse(_freqCtrl.text) ?? 1;
            if (title.isNotEmpty) {
              model.addHabit(title, freq);
              _titleCtrl.clear();
              _freqCtrl.text = '1';
              Navigator.of(context).pop();
            }
          }, child: const Text('Crear')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HabitModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Habit Tracker')),
      body: ListView.builder(
        itemCount: model.habits.length,
        itemBuilder: (_, i) {
          final Habit h = model.habits[i];
          return ListTile(
            title: Text(h.title),
            subtitle: Text('Frecuencia: ${h.frequencyPerWeek}/sem'),
            leading: Checkbox(value: h.completedToday, onChanged: (_) => model.toggleCompleted(h.id)),
            trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => model.deleteHabit(h.id)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(model),
        child: const Icon(Icons.add),
      ),
    );
  }
}