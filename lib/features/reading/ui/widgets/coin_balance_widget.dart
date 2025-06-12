import 'package:flutter/material.dart';

/// Widget that displays the user's coin balance
class CoinBalanceWidget extends StatelessWidget {
  final int coinBalance;
  final GlobalKey? globalKey;

  const CoinBalanceWidget({
    super.key,
    required this.coinBalance,
    this.globalKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: globalKey,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
          const SizedBox(width: 8),
          Text(
            coinBalance.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
