import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/expense.dart';
import 'app_database.dart';

part 'expense_repository.g.dart';
class ExpenseRepository {
  final AppDatabase appDatabase = AppDatabase();
  final String table = 'expense';
  Future<List<Expense>> getAll() async{
    var db = await appDatabase.open();
    var json = await db.query(table);
    return json.map((row) => Expense.fromMap(row)).toList();
  }
  Future<Expense?> getById(int id) async{
    var db = await appDatabase.open();
    final json = await db.query(table,where: 'id = ?',whereArgs: [id]);
    if(json.isEmpty){
      return null;
    }
    return Expense.fromMap(json.first);
  }
  Future<Expense> createExpense(Expense expense) async{
    var db = await appDatabase.open();
    var data = expense.toMap();
    data.remove('id');
    var id = await db.insert(table, data);
    return Expense(id:id, title: expense.title, category: expense.category, amount: expense.amount, date: expense.date);
  }
  Future<int> updateExpense(Expense user) async {
    var db = await appDatabase.open();
    return await db.update(table, user.toMap(),
        where: 'id = ?', whereArgs: [user.id]);
  }
  Future<int> deleteExpense(int id) async {
    var db = await appDatabase.open();
    return await db.delete(table, where: 'id= ?', whereArgs: [id]);
  }
}
@riverpod
ExpenseRepository expenseRepository(Ref ref) {
  return ExpenseRepository();
}
