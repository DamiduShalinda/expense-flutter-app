import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_manage/data/database/app_database.dart';
import 'package:expense_manage/providers/categories_provider.dart';
import 'package:expense_manage/providers/repositories_provider.dart';

Future<void> showCategoryFormBottomSheet(
  BuildContext context, {
  int? categoryId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => CategoryFormSheet(categoryId: categoryId),
  );
}

class CategoryFormSheet extends ConsumerStatefulWidget {
  const CategoryFormSheet({super.key, this.categoryId});

  final int? categoryId;

  @override
  ConsumerState<CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends ConsumerState<CategoryFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isIncome = false;
  int? _parentId;
  int _colorValue = Colors.blue.value;
  int _iconCodePoint = Icons.category_outlined.codePoint;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadIfEditing();
  }

  Future<void> _loadIfEditing() async {
    final id = widget.categoryId;
    if (id == null) return;

    setState(() => _loading = true);
    try {
      final repo = ref.read(categoriesRepositoryProvider);
      final category = await repo.requireCategory(id);
      _nameController.text = category.name;
      _isIncome = category.isIncome;
      _parentId = category.parentId;
      _colorValue = category.color;
      _iconCodePoint = category.icon;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.categoryId != null;
    final groupedAsync = ref.watch(categoriesByParentProvider);
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    final selectedColor = Color(_colorValue);
    final selectedIcon = IconData(_iconCodePoint, fontFamily: 'MaterialIcons');

    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: bottomPadding + 16,
        ),
        child: _loading
            ? const SizedBox(
                height: 160,
                child: Center(child: CircularProgressIndicator()),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isEditing ? 'Edit category' : 'Add category',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        if (isEditing)
                          PopupMenuButton<_CategoryMenuAction>(
                            onSelected: (action) =>
                                _onMenuAction(context, action),
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: _CategoryMenuAction.delete,
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) return 'Name is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('Income category'),
                      value: _isIncome,
                      onChanged: (value) {
                        setState(() {
                          _isIncome = value;
                          _parentId = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    groupedAsync.when(
                      data: (grouped) {
                        final root = (grouped[null] ?? const <Category>[])
                            .where((c) => c.isIncome == _isIncome)
                            .where((c) => c.id != widget.categoryId)
                            .toList();

                        return DropdownButtonFormField<int?>(
                          value: _validParent(_parentId, root),
                          decoration: const InputDecoration(
                            labelText: 'Parent (optional)',
                          ),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('None'),
                            ),
                            for (final p in root)
                              DropdownMenuItem<int?>(
                                value: p.id,
                                child: Text(p.name),
                              ),
                          ],
                          onChanged: (value) =>
                              setState(() => _parentId = value),
                        );
                      },
                      error: (error, _) =>
                          Text('Failed to load parents: $error'),
                      loading: () => const LinearProgressIndicator(),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: selectedColor.withOpacity(0.2),
                        foregroundColor: selectedColor,
                        child: Icon(selectedIcon),
                      ),
                      title: const Text('Preview'),
                      subtitle: Text(_isIncome ? 'Income' : 'Expense'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickColor(context),
                            icon: const Icon(Icons.palette_outlined),
                            label: const Text('Color'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickIcon(context),
                            icon: const Icon(Icons.emoji_objects_outlined),
                            label: const Text('Icon'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _loading ? null : () => _onSave(context),
                        child: Text(isEditing ? 'Save' : 'Create'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  int? _validParent(int? current, List<Category> parents) {
    if (current == null) return null;
    return parents.any((p) => p.id == current) ? current : null;
  }

  Future<void> _pickColor(BuildContext context) async {
    final picked = await showDialog<int>(
      context: context,
      builder: (context) => _ColorPickerDialog(initial: _colorValue),
    );
    if (picked == null) return;
    setState(() => _colorValue = picked);
  }

  Future<void> _pickIcon(BuildContext context) async {
    final picked = await showDialog<int>(
      context: context,
      builder: (context) => _IconPickerDialog(initial: _iconCodePoint),
    );
    if (picked == null) return;
    setState(() => _iconCodePoint = picked);
  }

  Future<void> _onSave(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final repo = ref.read(categoriesRepositoryProvider);
    final name = _nameController.text.trim();

    setState(() => _loading = true);
    try {
      final id = widget.categoryId;
      if (id == null) {
        await repo.createCategory(
          name: name,
          parentId: _parentId,
          color: _colorValue,
          icon: _iconCodePoint,
          isIncome: _isIncome,
        );
      } else {
        await repo.updateCategory(
          categoryId: id,
          name: name,
          parentId: _parentId,
          color: _colorValue,
          icon: _iconCodePoint,
          isIncome: _isIncome,
        );
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onMenuAction(
    BuildContext context,
    _CategoryMenuAction action,
  ) async {
    final categoryId = widget.categoryId;
    if (categoryId == null) return;

    switch (action) {
      case _CategoryMenuAction.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete category?'),
            content: const Text(
              'If this category is used, transactions will be reassigned to Uncategorized.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (confirmed != true) return;

        setState(() => _loading = true);
        try {
          final repo = ref.read(categoriesRepositoryProvider);
          await repo.deleteCategory(categoryId);
          if (mounted) Navigator.pop(context);
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
        } finally {
          if (mounted) setState(() => _loading = false);
        }
        break;
    }
  }
}

enum _CategoryMenuAction { delete }

class _ColorPickerDialog extends StatelessWidget {
  const _ColorPickerDialog({required this.initial});

  final int initial;

  static const _colors = <Color>[
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a color'),
      content: SizedBox(
        width: 320,
        child: GridView.count(
          crossAxisCount: 5,
          shrinkWrap: true,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            for (final color in _colors)
              InkWell(
                onTap: () => Navigator.pop(context, color.value),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: color.value == initial
                        ? Border.all(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 3,
                          )
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class _IconPickerDialog extends StatelessWidget {
  const _IconPickerDialog({required this.initial});

  final int initial;

  static const _icons = <IconData>[
    Icons.category_outlined,
    Icons.fastfood_outlined,
    Icons.local_grocery_store_outlined,
    Icons.directions_car_outlined,
    Icons.home_outlined,
    Icons.shopping_bag_outlined,
    Icons.phone_android_outlined,
    Icons.receipt_long_outlined,
    Icons.local_hospital_outlined,
    Icons.school_outlined,
    Icons.flight_outlined,
    Icons.sports_soccer_outlined,
    Icons.paid_outlined,
    Icons.card_giftcard_outlined,
    Icons.pets_outlined,
    Icons.train_outlined,
    Icons.movie_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick an icon'),
      content: SizedBox(
        width: 320,
        child: GridView.count(
          crossAxisCount: 5,
          shrinkWrap: true,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            for (final icon in _icons)
              InkWell(
                onTap: () => Navigator.pop(context, icon.codePoint),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: icon.codePoint == initial
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
