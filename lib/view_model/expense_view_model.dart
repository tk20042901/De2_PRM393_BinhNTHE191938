import 'package:de_2/model/expense.dart';
import 'package:de_2/repo/expense_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_view_model.g.dart';

@riverpod
class ExpenseViewModel extends _$ExpenseViewModel {
  @override
  Future<List<Expense>> build() {
    return ref.watch(expenseRepositoryProvider).getAll();
  }

  Future<void> createExpense(Expense expense) async {
    await ref.read(expenseRepositoryProvider).createExpense(expense);
    ref.invalidateSelf();
  }

  Future<void> updateExpense(Expense expense) async {
    await ref.read(expenseRepositoryProvider).updateExpense(expense);
    ref.invalidateSelf();
  }

  Future<void> deleteExpense(int id) async {
    await ref.read(expenseRepositoryProvider).deleteExpense(id);
    ref.invalidateSelf();
  }

  Future<Expense?> getExpenseById(int id) {
    return ref.read(expenseRepositoryProvider).getById(id);
  }
}
