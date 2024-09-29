import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_id_week_04/core/theme/colors.dart';
import 'package:task_id_week_04/feature/addtask/presenation/controller/task_cubit.dart';
import 'package:task_id_week_04/feature/addtask/presenation/screens/add_screen.dart';
import 'package:task_id_week_04/feature/addtask/presenation/screens/widgets/edit_tasks_screen.dart';

import '../../../addtask/presenation/data/local_datebase/sqllite_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedTaskId;
  int? _longPressedTaskId;
  static final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskCubit(dbHelper)..loadTasks(),
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(
            Icons.home,
            color: secondcolor,
          ),
          backgroundColor: maincolor,
          actions: const [
            SizedBox(width: 10),
            Text(
              'My To-Do List',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: secondcolor),
            ),
            SizedBox(width: 180),
          ],
        ),
        body: Stack(
          children: [
            Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/images/home_background.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  return ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      final isSelected = _selectedTaskId == task['id'];
                      final isLongPressed = _longPressedTaskId == task['id'];

                      return Container(
                        color: isLongPressed
                            ? Colors.red
                            : (isSelected
                                ? Colors.white10
                                : Colors.transparent),
                        child: ListTile(
                          // Display task number followed by name
                          title: Text(
                            'Task ${index + 1}: ${task['name']}', // Task 1, Task 2, etc.
                            style: TextStyle(
                              decoration: task['completed'] == 1
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(task['description']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                checkColor: secondcolor,
                                value: task['completed'] == 1,
                                onChanged: (value) {
                                  context
                                      .read<TaskCubit>()
                                      .toggleTaskCompletion(task['id'], value!);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              _selectedTaskId = task['id'];
                              _longPressedTaskId = null;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditTaskScreen(task: task),
                              ),
                            );
                          },
                          onLongPress: () {
                            setState(() {
                              _longPressedTaskId = task['id'];
                              _selectedTaskId = null;
                            });
                            Future.delayed(const Duration(milliseconds: 300),
                                () {
                              context.read<TaskCubit>().deleteTask(task['id']);
                            });
                          },
                        ),
                      );
                    },
                  );
                } else if (state is TaskError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('No tasks available.'));
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: maincolor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddTaskScreen()),
            );
          },
          child: const Icon(Icons.add_task),
        ),
      ),
    );
  }
}
