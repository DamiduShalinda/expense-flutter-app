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

    final resolvedColor = switch (amount.sign) {
      1 => positiveColor ?? scheme.primary,
      -1 => negativeColor ?? scheme.error,
      _ => zeroColor ?? scheme.onSurfaceVariant,
    };

    return Text(
      text,
      style: (style ?? Theme.of(context).textTheme.bodyLarge)?.copyWith(
        color: resolvedColor,
      ),
    );
  }
}
