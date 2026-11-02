// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExpenseViewModel)
final expenseViewModelProvider = ExpenseViewModelProvider._();

final class ExpenseViewModelProvider
    extends $AsyncNotifierProvider<ExpenseViewModel, List<Expense>> {
  ExpenseViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseViewModelHash();

  @$internal
  @override
  ExpenseViewModel create() => ExpenseViewModel();
}

String _$expenseViewModelHash() => r'a1a17d444a3c90865aab1b331bd5a240bf7414f8';

abstract class _$ExpenseViewModel extends $AsyncNotifier<List<Expense>> {
  FutureOr<List<Expense>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Expense>>, List<Expense>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Expense>>, List<Expense>>,
              AsyncValue<List<Expense>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
