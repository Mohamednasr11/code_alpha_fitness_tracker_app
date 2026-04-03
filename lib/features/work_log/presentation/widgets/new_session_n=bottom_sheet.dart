import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';

class NewSessionBottomSheet extends StatefulWidget {
  final Function(String name) onCreateSession;
  const NewSessionBottomSheet({super.key, required this.onCreateSession});

  @override
  State<NewSessionBottomSheet> createState() => _NewSessionBottomSheetState();
}

class _NewSessionBottomSheetState extends State<NewSessionBottomSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _quickNames = [
    'Push Day 💪',
    'Pull Day 🏋️',
    'Leg Day 🦵',
    'Upper Body',
    'Lower Body',
    'Full Body',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('New Workout',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Quick name chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickNames.map((name) {
                return GestureDetector(
                  onTap: () => _controller.text = name,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Text(name,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Name field
            TextFormField(
              controller: _controller,
              style: const TextStyle(color: AppColors.textPrimary),
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Workout name...',
                prefixIcon:
                Icon(Iconsax.edit, color: AppColors.textHint, size: 20),
              ),
              validator: (v) =>
              v == null || v.trim().isEmpty ? 'Enter a name' : null,
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onCreateSession(_controller.text.trim());
                }
              },
              child: const Text('Start Workout'),
            ),
          ],
        ),
      ),
    );
  }
}