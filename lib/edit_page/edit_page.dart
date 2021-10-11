import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/main_page/main_model.dart';

class EditPage extends StatelessWidget {
  final int currentTodoIndex;

  const EditPage({Key? key, required this.currentTodoIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainModel = context.read(mainProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("todo app"),
        actions: [
          Consumer(builder: (context, watch, child) {

            final nameController = watch(mainProvider).nameController;
            final editingController = watch(mainProvider).editingController;

            return IconButton(
              onPressed: () {
                mainModel.renameTodo(currentTodoIndex, nameController.text);
                mainModel.editTodo(currentTodoIndex, editingController.text);
              },
              icon: const Icon(Icons.save),
            );
          })
        ],
      ),
      body: Consumer(builder: (context, watch, child) {
        final nameController = watch(mainProvider).nameController;
        final editingController = watch(mainProvider).editingController;

        return Column(
          children: [
            TextField(
              maxLength: 40,
              maxLines: 1,
              controller: nameController,
            ),
            Expanded(
              child: TextField(
                maxLines: null,
                maxLength: null,
                controller: editingController,
                expands: true,
                decoration: const InputDecoration(
                    hintText: "write your todo description here"
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}