import 'package:chat/core/common/model/media.dart';
import 'package:flutter/material.dart';

import 'package:chat/src/chat/presentation/widgets/circular_container.dart';
import 'package:chat/utils/color/color.dart';

class FileChat extends StatelessWidget {
  const FileChat({
    super.key,
    required this.file,
    this.borderRadius,
    this.vertical = false,
  });

  final Media file;
  final BorderRadius? borderRadius;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (vertical) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: TColors.fileMessageBoxColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            const TCircularContainer(
              backgroundColor: Color.fromARGB(255, 170, 200, 235),
              padding: EdgeInsets.all(10),
              borderRadius: 30,
              child: Icon(Icons.insert_drive_file_sharp, size: 30),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                file.metaData.title ?? file.url,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      constraints: BoxConstraints(maxWidth: size.width * 0.7),
      decoration: BoxDecoration(
        color: TColors.fileMessageBoxColor,
        borderRadius: borderRadius,
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TCircularContainer(
            backgroundColor: Color.fromARGB(255, 170, 200, 235),
            padding: EdgeInsets.all(7),
            borderRadius: 30,
            child: Icon(Icons.insert_drive_file_sharp),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              file.metaData.title ?? file.url,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
