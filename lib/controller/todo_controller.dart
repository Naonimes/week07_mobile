import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:week07/model/todo.dart';

class TodoController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final judulCtr = TextEditingController();
  final deskripsiCtr = TextEditingController();
  final tanggalCtr = TextEditingController();
  DateTime? tanggal;
  final todoList = <Todo>[].obs;

  bool addTodo() {
    if (!formKey.currentState!.validate()) return false;

    todoList.add(
      Todo(
        judul: judulCtr.text.trim(),
        deskripsi: deskripsiCtr.text.trim(),
        tanggal: tanggal!,
        tanggalDibuat: DateTime.now(),
      ),
    );
    judulCtr.clear();
    deskripsiCtr.clear();
    tanggalCtr.clear();
    tanggal = null;
    return true;
  }

  void toggleSelesai(int index) {
    final todo = todoList[index];
    todoList[index] = todo.copyWith(selesai: !todo.selesai);
  }

  void updateTodo(
    int index, {
    required String judul,
    required String deskripsi,
    required DateTime tanggal,
  }) {
    final todo = todoList[index];
    todoList[index] = todo.copyWith(
      judul: judul.trim(),
      deskripsi: deskripsi.trim(),
      tanggal: tanggal,
    );
  }

  void deleteTodo(int index) {
    todoList.removeAt(index);
  }

  @override
  void onClose() {
    judulCtr.dispose();
    deskripsiCtr.dispose();
    tanggalCtr.dispose();
    super.onClose();
  }

  void pilihTanggal(DateTime picked) {
  tanggal = picked;
  tanggalCtr.text = picked.toString().substring(0, 10);
}
}