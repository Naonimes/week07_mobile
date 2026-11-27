import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:week07/controller/todo_controller.dart';
import 'package:week07/view/detail_pages.dart';


class TodoPages extends StatefulWidget {
  const TodoPages({super.key});

  @override
  State<TodoPages> createState() => _TodoPagesState();
}

class _TodoPagesState extends State<TodoPages> {
  final TodoController todoCtr = Get.put(TodoController());

  Future<void> _pilihTanggal() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: todoCtr.tanggal ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      todoCtr.pilihTanggal(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: todoCtr.formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: todoCtr.judulCtr,
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
                    controller: todoCtr.deskripsiCtr,
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
                    controller: todoCtr.tanggalCtr,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Tenggat",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: _pilihTanggal,
                    validator: (value) {
                      if (todoCtr.tanggal == null) {
                        return "Tanggal wajib dipilih";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () {
                        final berhasil = todoCtr.addTodo();
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                berhasil
                                    ? "Todo ditambahkan ke daftar"
                                    : "Belum bisa disimpan, lengkapi isian yang ditandai merah",
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );
                      },
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("Tambah Todo"),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Obx(() {
              if (todoCtr.todoList.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Text(
                      "Belum ada todo. Isi form di atas untuk menambah.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final jumlahSelesai = todoCtr.todoList
                  .where((todo) => todo.selesai)
                  .length;

              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text(
                            "Daftar Todo",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "$jumlahSelesai dari ${todoCtr.todoList.length} selesai",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        clipBehavior: Clip.antiAlias,
                        child: ListView.separated(
                          itemCount: todoCtr.todoList.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 1, indent: 56),
                          itemBuilder: (context, index) {
                            final todo = todoCtr.todoList[index];
                            return ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 4,
                                right: 12,
                              ),
                              leading: Checkbox(
                                value: todo.selesai,
                                onChanged: (_) => todoCtr.toggleSelesai(index),
                              ),
                              title: Text(
                                todo.judul,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: todo.selesai
                                      ? Colors.grey.shade600
                                      : null,
                                  decoration: todo.selesai
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              subtitle: Text(
                                "Tenggat ${todo.tanggal.toString().substring(0, 10)}",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              trailing: Icon(Icons.chevron_right),
                              onTap: () =>
                                  Get.to(() => DetailPages(index: index)),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}