import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/expense.dart';
import '../view_model/expense_view_model.dart';

class EditPage extends ConsumerStatefulWidget {
  const EditPage({super.key, required this.expense});

  final Expense expense;

  @override
  ConsumerState<EditPage> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {
  late final titleController = TextEditingController(
    text: widget.expense.title,
  );
  late final categoryController = TextEditingController(
    text: widget.expense.category,
  );
  late final amountController = TextEditingController(
    text: widget.expense.amount.toString(),
  );
  late final dateController = TextEditingController(text: widget.expense.date);

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa khoản chi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Tên khoản chi *',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Số tiền *',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Danh mục *',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Ngày chi tiêu *',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () {}, child: const Text('Huỷ')),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final title = titleController.text.trim();
                        final category = categoryController.text.trim();
                        final date = dateController.text.trim();
                        final amount = int.tryParse(amountController.text.trim());
                        final id = widget.expense.id;
                        if (id == null) return;

                        await ref.read(expenseViewModelProvider.notifier).updateExpense(
                          Expense(
                            id: id,
                            title: title,
                            category: category,
                            amount: amount!,
                            date: date,
                          ),
                        );
                        if (mounted) Navigator.of(context).pop();
                      },
                      child: const Text('Lưu'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
