import 'package:flutter/material.dart';

class FilePathTile extends StatelessWidget {
  const FilePathTile({
    required this.filePath,
    required this.onTap,
    this.isLoading = false,
    super.key,
  });
  
  final String filePath;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              filePath,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }
}
