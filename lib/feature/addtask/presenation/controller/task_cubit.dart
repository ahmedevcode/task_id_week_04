import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:task_id_week_04/feature/addtask/presenation/data/local_datebase/sqllite_database.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final DatabaseHelper dbHelper;

  TaskCubit(this.dbHelper) : super(TaskInitial());

  // Load all tasks from database
  void loadTasks() async {
    try {
      emit(TaskLoading()); // Emit loading state
      final tasks = await dbHelper.queryAllTasks();
      emit(TaskLoaded(tasks)); // Emit loaded state with tasks
    } catch (error) {
      emit(TaskError("Failed to load tasks")); // Emit error state
    }
  }

  // Add a new task
  void addTask(String name, String description) async {
    try {
      final task = {
        'name': name,
        'description': description,
        'completed': 0,
      };
      await dbHelper.insertTask(task);
      loadTasks(); // Reload tasks after adding a new one
    } catch (error) {
      emit(TaskError("Failed to add task")); // Emit error state
    }
  }

  // Edit a task
  void editTask(int id, String name, String description, bool completed) async {
    try {
      final task = {
        'id': id,
        'name': name,
        'description': description,
        'completed': completed ? 1 : 0,
      };
      await dbHelper.updateTask(task);
      loadTasks(); // Reload tasks after editing
    } catch (error) {
      emit(TaskError("Failed to edit task")); // Emit error state
    }
  }

  // Delete a task
  deleteTask(int id) async {
    try {
      // Find the task to delete from the current state
      final currentState = state;
      if (currentState is TaskLoaded) {
        // Remove the task from the local list first
        final updatedTasks = List<Map<String, dynamic>>.from(currentState.tasks)
          ..removeWhere((task) => task['id'] == id);

        // Emit the updated state with the remaining tasks
        emit(TaskLoaded(updatedTasks));

        // Now delete the task from the database
        await dbHelper.deleteTask(id);
      }
    } catch (error) {
      emit(TaskError("Failed to delete task")); // Emit error state
    }
  }

  // Mark task as completed
  void toggleTaskCompletion(int id, bool completed) async {
    try {
      final task = {
        'id': id,
        'completed': completed ? 1 : 0,
      };
      await dbHelper.updateTask(task);
      loadTasks(); // Reload tasks after toggling completion
    } catch (error) {
      emit(TaskError(
          "Failed to update task completion status")); // Emit error state
    }
  }
}
