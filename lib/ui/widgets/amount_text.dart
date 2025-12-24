import 'package:flutter/material.dart';

class AmountText extends StatelessWidget {
  const AmountText(
    this.amount, {
    super.key,
    this.style,
    this.currencyCode,
    this.positiveColor,
    this.negativeColor,
    this.zeroColor,
  });

  final int amount;
  final TextStyle? style;
  final String? currencyCode;
  final Color? positiveColor;
  final Color? negativeColor;
  final Color? zeroColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final isNegative = amount < 0;
    final abs = amount.abs();
    final code = currencyCode?.trim();
    final withCurrency = (code != null && code.isNotEmpty)
        ? '${code.toUpperCase()} $abs'
        : '$abs';
    final text = isNegative ? '-$withCurrency' : withCurrency;
    final semanticLabel = _semanticAmountLabel(
      amount: amount,
      currencyCode: code,
    );

    final resolvedColor = switch (amount.sign) {
      1 => positiveColor ?? scheme.primary,
      -1 => negativeColor ?? scheme.error,
      _ => zeroColor ?? scheme.onSurfaceVariant,
    };

    final textColor = _ensureContrast(
      color: resolvedColor,
      background: scheme.surface,
      fallback: scheme.onSurface,
    );

    return Semantics(
      label: semanticLabel,
      child: Text(
        text,
        style: (style ?? Theme.of(context).textTheme.bodyLarge)?.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}

String _semanticAmountLabel({
  required int amount,
  required String? currencyCode,
}) {
  final code = currencyCode?.trim();
  final abs = amount.abs();
  final amountText = (code != null && code.isNotEmpty)
      ? '$abs ${code.toUpperCase()}'
      : '$abs';
  if (amount == 0) return 'Zero $amountText';
  return amount < 0 ? 'Negative $amountText' : 'Positive $amountText';
}

Color _ensureContrast({
  required Color color,
  required Color background,
  required Color fallback,
}) {
  final ratio = _contrastRatio(color, background);
  if (ratio >= 4.5) return color;
  return fallback;
}

double _contrastRatio(Color a, Color b) {
  final l1 = a.computeLuminance();
  final l2 = b.computeLuminance();
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}
