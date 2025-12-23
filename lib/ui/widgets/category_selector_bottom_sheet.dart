import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/categories_provider.dart';

Future<Category?> showCategorySelectorBottomSheet(
  BuildContext context, {
  int? selectedCategoryId,
  bool? isIncome,
}) {
  return showModalBottomSheet<Category>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      return CategorySelectorBottomSheet(
        selectedCategoryId: selectedCategoryId,
        isIncome: isIncome,
      );
    },
  );
}

class CategorySelectorBottomSheet extends ConsumerWidget {
  const CategorySelectorBottomSheet({
    super.key,
    this.selectedCategoryId,
    this.isIncome,
  });

  final int? selectedCategoryId;
  final bool? isIncome;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedAsync = ref.watch(categoriesByParentProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: groupedAsync.when(
          data: (grouped) {
            final parents = (grouped[null] ?? [])
                .where((c) => isIncome == null || c.isIncome == isIncome)
                .toList();

            if (parents.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('No categories yet')),
              );
            }

            return ListView(
              shrinkWrap: true,
              children: [
                const ListTile(title: Text('Select category')),
                for (final parent in parents) ...[
                  ListTile(
                    title: Text(parent.name),
                    selected: parent.id == selectedCategoryId,
                    onTap: () => Navigator.pop(context, parent),
                  ),
                  for (final child in (grouped[parent.id] ?? []).where(
                    (c) => isIncome == null || c.isIncome == isIncome,
                  ))
                    ListTile(
                      contentPadding: const EdgeInsetsDirectional.only(
                        start: 32,
                        end: 16,
                      ),
                      title: Text(child.name),
                      selected: child.id == selectedCategoryId,
                      onTap: () => Navigator.pop(context, child),
                    ),
                  const Divider(height: 1),
                ],
              ],
            );
          },
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Failed to load categories: $error'),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
