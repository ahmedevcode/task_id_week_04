import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_id_week_04/feature/addtask/presenation/controller/task_cubit.dart';
import 'package:task_id_week_04/feature/home/presentation/screens/home_screen.dart';

import '../../../../../core/theme/colors.dart';
import '../../data/local_datebase/sqllite_database.dart';

class EditTaskScreen extends StatelessWidget {
  final Map<String, dynamic> task;

  EditTaskScreen({required this.task});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialize controllers with existing task data
    nameController.text = task['name'];
    descriptionController.text = task['description'];

    return BlocProvider(
        create: (context) =>
            TaskCubit(DatabaseHelper()), // Provide TaskCubit here
        child: Scaffold(
          appBar: AppBar(
              title: const Text(
            'Edit Task',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          body: Stack(children: [
            Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/images/editbackground.jpg',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is TaskError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }

                  return Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(labelText: 'Task Name'),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Trigger the edit task method
                          context.read<TaskCubit>().editTask(
                                task['id'],
                                nameController.text,
                                descriptionController.text,
                                task['completed'] == 1,
                              );

                          // Optionally, you could navigate back after successful edit
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Save changes',
                          style: TextStyle(color: secondcolor),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ]),
        ));
  }
}
