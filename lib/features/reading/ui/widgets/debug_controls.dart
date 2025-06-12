import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/book_reader_cubit.dart';

/// Debug controls for testing storage functionality
class DebugControls extends StatelessWidget {
  const DebugControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Debug Controls',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDebugButton(
                context,
                icon: Icons.refresh,
                label: 'Reset',
                color: Colors.red,
                onTap: () => _showResetConfirmation(context),
              ),
              const SizedBox(width: 8),
              _buildDebugButton(
                context,
                icon: Icons.add,
                label: '+10 Coins',
                color: Colors.green,
                onTap:
                    () => context.read<BookReaderCubit>().addCoinsAndSave(10),
              ),
              const SizedBox(width: 8),
              _buildDebugButton(
                context,
                icon: Icons.add_circle,
                label: '+50 Coins',
                color: Colors.blue,
                onTap:
                    () => context.read<BookReaderCubit>().addCoinsAndSave(50),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDebugButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade800,
          title: Text('Reset Progress', style: TextStyle(color: Colors.white)),
          content: Text(
            'Are you sure you want to reset all progress?\nThis will clear coins and lock all chapters.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<BookReaderCubit>().resetProgress();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Progress reset successfully!'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: Text('Reset', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
