import 'package:de_2/view_model/expense_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _currency = 'VND';

  @override
  void initState() {
    super.initState();
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final saved = await SharedPreferencesAsync().getString('currency_unit');
    if (!mounted || saved == null || (saved != 'VND' && saved != 'USD')) return;
    setState(() => _currency = saved);
  }

  Future<void> _showCurrencyDialog() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Đơn vị tiền tệ'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(dialogContext).pop('VND'),
            child: Row(
              children: [
                const Text('VND (Việt Nam Đồng)'),
                const Spacer(),
                if (_currency == 'VND') const Icon(Icons.check),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(dialogContext).pop('USD'),
            child: Row(
              children: [
                const Text('USD (Đô la Mỹ)'),
                const Spacer(),
                if (_currency == 'USD') const Icon(Icons.check),
              ],
            ),
          ),
        ],
      ),
    );

    if (!mounted || selected == null || selected == _currency) return;
    await SharedPreferencesAsync().setString('currency_unit', selected);
    if (!mounted) return;
    setState(() => _currency = selected);
  }

  @override
  Widget build(BuildContext context) {
    final expenseAsync = ref.watch(expenseViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản lý chi tiêu',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: _showCurrencyDialog,
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: expenseAsync.when(
        loading: () => CircularProgressIndicator(),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (expenses) => ListView(
          children: expenses.map((e) {
            return Card(
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(flex: 2, child: Text(e.title)),
                    Expanded(child: Text(e.date, textAlign: TextAlign.end)),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Card(child: Text(e.category)),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${e.amount} $_currency',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => EditPage(expense: e),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}