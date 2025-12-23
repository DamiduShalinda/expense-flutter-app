import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/categories_provider.dart';
import 'package:expense_manage/ui/screens/category_form_screen.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedAsync = ref.watch(categoriesByParentProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: groupedAsync.when(
        data: (grouped) {
          final parents = grouped[null] ?? const <Category>[];
          if (parents.isEmpty) {
            return const Center(child: Text('No categories yet'));
          }

          return ListView(
            children: [
              for (final parent in parents) ...[
                _CategoryTile(
                  category: parent,
                  onTap: () => _openEdit(context, parent.id),
                  children: (grouped[parent.id] ?? const [])
                      .map(
                        (child) => _CategoryTile(
                          category: child,
                          dense: true,
                          onTap: () => _openEdit(context, child.id),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          );
        },
        error: (error, _) => Center(child: Text('Failed to load: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCategoryFormBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openEdit(BuildContext context, int categoryId) {
    showCategoryFormBottomSheet(context, categoryId: categoryId);
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.onTap,
    this.children,
    this.dense = false,
  });

  final Category category;
  final VoidCallback onTap;
  final List<Widget>? children;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final leading = _CategoryPreview(
      colorValue: category.color,
      iconCodePoint: category.icon,
    );

    final title = Text(category.name);
    final subtitle = Text(category.isIncome ? 'Income' : 'Expense');

    if (children == null || children!.isEmpty) {
      return ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        dense: dense,
        onTap: onTap,
      );
    }

    return ExpansionTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      children: children!,
    );
  }
}

class _CategoryPreview extends StatelessWidget {
  const _CategoryPreview({
    required this.colorValue,
    required this.iconCodePoint,
  });

  final int colorValue;
  final int iconCodePoint;

  @override
  Widget build(BuildContext context) {
    final color = Color(colorValue);
    final icon = IconData(iconCodePoint, fontFamily: 'MaterialIcons');

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      foregroundColor: color,
      child: Icon(icon),
    );
  }
}
