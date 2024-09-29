import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:task_id_week_04/core/theme/colors.dart';
import 'package:task_id_week_04/feature/addtask/presenation/controller/task_cubit.dart';
import 'package:task_id_week_04/feature/addtask/presenation/data/local_datebase/sqllite_database.dart';
import 'package:task_id_week_04/feature/home/presentation/screens/home_screen.dart';

class AddTaskScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  static final DatabaseHelper dbHelper = DatabaseHelper();

  final _formKey = GlobalKey<FormState>(); // Global key for the form

  AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: secondcolor,
            ),
          ),
          backgroundColor: maincolor,
          title: const Text(
            'Add Task',
            style: TextStyle(color: secondcolor, fontWeight: FontWeight.bold),
          )),
      body: Stack(children: [
        Opacity(
          opacity: 0.4,
          child: Image.asset(
            'assets/images/add_background.jpeg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
        BlocProvider(
          create: (context) => TaskCubit(dbHelper),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, // Assign the key to the form
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Task Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Task name cannot be empty'; // Validation message
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 20),

                  // BlocBuilder to react to different states
                  BlocBuilder<TaskCubit, TaskState>(
                    builder: (context, state) {
                      if (state is TaskLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is TaskLoaded) {
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Only save if the form is valid
                              context.read<TaskCubit>().addTask(
                                    nameController.text,
                                    descriptionController.text,
                                  );
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Save Task',
                          ),
                        );
                      } else if (state is TaskError) {
                        return Text('Error: ${state.message}');
                      } else {
                        const SizedBox(
                          height: 10,
                        );
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Only save if the form is valid
                              context.read<TaskCubit>().addTask(
                                    nameController.text,
                                    descriptionController.text,
                                  );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                maincolor), // Change button color
                            foregroundColor: WidgetStateProperty.all<Color>(
                                maincolor), // Change text color
                            elevation: WidgetStateProperty.all<double>(
                                8.0), // Change button elevation
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  horizontal: 32.0,
                                  vertical: 24.0), // Change button padding
                            ),
                            shape: WidgetStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    40.0), // Change button border radius
                              ),
                            ),
                          ),
                          child: const Text(
                            'Save Task',
                            style: TextStyle(color: secondcolor),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
