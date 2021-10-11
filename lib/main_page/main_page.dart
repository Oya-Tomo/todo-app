import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/todo.dart';
import 'package:todo_app/edit_page/edit_page.dart';
import 'package:todo_app/main_page/main_model.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainModel = context.read(mainProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("todo app"),
        actions: [
          Consumer(builder: (context, watch, child) {
            final nameController = TextEditingController();
            final nameList = watch(mainProvider).todoList.map((Todo todo) => todo.title).toList();

            return IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("新しいTodoの作成"),
                      content: SizedBox(
                        width: 200,
                        height: 150,
                        child: Column(
                          children: [
                            const Text("既存のTodoの名前と重複しないようにしてください。"),
                            TextField(
                              controller: nameController,
                              maxLines: 1,
                              maxLength: 40,
                              decoration: const InputDecoration(
                                labelText: "Todoの名前",
                                hintText: "Todo name",
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            if (nameList.contains(nameController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("同じ名前のTodoがすでに存在します。"),
                                  duration: Duration(seconds: 4),
                                ),
                              );
                            } else if (nameController.text == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("名前の欄が空欄です。"),
                                  duration: Duration(seconds: 4),
                                ),
                              );
                            } else {
                              Navigator.pop(context);
                              mainModel.addTodo(nameController.text);
                            }
                          },
                          child: const Text("ok"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.add),
            );
          })
        ],
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final todoList = watch(mainProvider).todoList;
          return ListView(
            children: todoList.asMap().entries.map((todoMap) {
              return ExpansionTile(
                leading: const Icon(Icons.comment),
                title: Text(todoMap.value.title),
                children: [
                  Column(
                    children: [
                      Text(todoMap.value.text),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return EditPage(currentTodoIndex: todoMap.key);
                              }));
                              mainModel.openTodo(todoMap.key);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Todoの削除"),
                                    content: const Text(
                                        "todoを完全に削除します。削除した後は復元できなります。よろしいですか？"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          mainModel.deleteTodo(todoMap.key);
                                        },
                                        child: const Text("ok"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete_forever),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
