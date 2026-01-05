import 'package:flutter/material.dart';
import '../models/unit_model.dart';
import 'need_attention_item.dart';

class NeedsAttentionSheet extends StatelessWidget {
  final List<UnitModel> items;

  const NeedsAttentionSheet({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // Determine screen height percentage for the sheet
    // If list is small, it wraps content. If large, it takes max 85% height.
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          color: Colors.white, // Match surface color
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const SizedBox(height: 8),
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Center(
                  child: const Text(
                    'NEEDS ATTENTION',
                    style: TextStyle(
                      fontFamily: 'Host Grotesk',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),

              // List
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(
                        height: 10,
                      ), // Gap matching the main list
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ), // Match page padding
                      child: NeedsAttentionItem(
                        unit: items[index],
                        index: index,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
