import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:week07/controller/todo_controller.dart';

class DetailPages extends StatefulWidget {
  final int index;
  const DetailPages({super.key, required this.index});

  @override
  State<DetailPages> createState() => _DetailPagesState();
}

class _DetailPagesState extends State<DetailPages> {
  final TodoController todoCtr = Get.find<TodoController>();

  void _showEditDialog() {
    final todo = todoCtr.todoList[widget.index];
    final editFormKey = GlobalKey<FormState>();
    final editJudulCtr = TextEditingController(text: todo.judul);
    final editDeskripsiCtr = TextEditingController(text: todo.deskripsi);
    DateTime editTanggal = todo.tanggal;
    final editTanggalCtr = TextEditingController(
      text: editTanggal.toString().substring(0, 10),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Todo"),
          content: SingleChildScrollView(
            child: Form(
              key: editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: editJudulCtr,
                    decoration: InputDecoration(labelText: "Judul"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Judul wajib diisi";
                      }
                      if (value.trim().length < 3) {
                        return "Judul minimal 3 karakter";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: editDeskripsiCtr,
                    decoration: InputDecoration(labelText: "Deskripsi"),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Deskripsi wajib diisi";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: editTanggalCtr,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Tenggat",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: editTanggal,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        editTanggal = picked;
                        editTanggalCtr.text = picked.toString().substring(0, 10);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Batal"),
            ),
            FilledButton(
              onPressed: () {
                if (editFormKey.currentState!.validate()) {
                  todoCtr.updateTodo(
                    widget.index,
                    judul: editJudulCtr.text,
                    deskripsi: editDeskripsiCtr.text,
                    tanggal: editTanggal,
                  );
                  Get.back();
                  ScaffoldMessenger.of(this.context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text("Todo berhasil diperbarui"),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                }
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hapus Todo"),
          content: Text("Yakin ingin menghapus todo ini?"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Batal"),
            ),
            FilledButton(
              onPressed: () {
                Get.back();
                Get.back();
                todoCtr.deleteTodo(widget.index);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(color: Colors.grey.shade700);

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Todo"),
        actions: [
          IconButton(
            onPressed: _showEditDialog,
            icon: Icon(Icons.edit),
            tooltip: "Edit",
          ),
          IconButton(
            onPressed: _showDeleteDialog,
            icon: Icon(Icons.delete),
            tooltip: "Hapus",
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (widget.index >= todoCtr.todoList.length) {
              return SizedBox.shrink();
            }
            final todo = todoCtr.todoList[widget.index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.judul,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: todo.selesai
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  todo.selesai ? "Sudah selesai" : "Belum selesai",
                  style: labelStyle,
                ),
                SizedBox(height: 16),
                Text(todo.deskripsi, style: TextStyle(fontSize: 16)),
                Divider(height: 32),
                Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text("Tenggat", style: labelStyle),
                    ),
                    Expanded(
                      child: Text(todo.tanggal.toString().substring(0, 10)),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text("Dibuat", style: labelStyle),
                    ),
                    Expanded(
                      child: Text(
                        todo.tanggalDibuat.toString().substring(0, 16),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: todo.selesai
                      ? OutlinedButton(
                          onPressed: () => todoCtr.toggleSelesai(widget.index),
                          child: Text("Tandai Belum Selesai"),
                        )
                      : FilledButton(
                          onPressed: () => todoCtr.toggleSelesai(widget.index),
                          child: Text("Tandai Selesai"),
                        ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}