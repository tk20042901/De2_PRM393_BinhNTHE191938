class Expense {
  final int? id;
  final String title;
  final String category;
  final int amount;
  final String date;

  Expense({
    this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
  });

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'date': date,
    };
  }

  factory Expense.fromMap(Map<String, Object?> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String,
      category: map['category'] as String,
      amount: map['amount'] as int,
      date: map['date'] as String,
    );
  }
}