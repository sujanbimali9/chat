import 'dart:developer';

import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/chat/presentation/widgets/message_field_icon.dart';
import 'package:chat/src/utils/color/color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageField extends HookWidget {
  const MessageField({
    super.key,
    required this.user,
    required this.currentUser,
  });

  final User user;
  final User currentUser;
  @override
  Widget build(BuildContext context) {
    Future<String?> pickFile(FileType type) async {
      final status = await Permission.storage.status;
      try {
        if (status.isGranted) {
          if (type == FileType.image) {
            final picker = FilePicker.platform;
            final result = await picker.pickFiles(
                type: FileType.image, allowMultiple: false);
            return result?.files.first.path;
          } else if (type == FileType.video) {
            final picker = FilePicker.platform;
            final result = await picker.pickFiles(type: FileType.video);
            return result?.files.first.path;
          } else {
            final picker =
                await FilePicker.platform.pickFiles(allowMultiple: false);
            return picker?.files.first.path;
          }
        } else if (status.isPermanentlyDenied) {
          openAppSettings();
          return null;
        } else {
          await Permission.storage.request();
          return pickFile(type);
        }
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }

    final TextEditingController controller = useTextEditingController();

    useEffect(() {
      final subscription =
          KeyboardVisibilityController().onChange.listen((visible) {
        if (!visible) {}
      });
      return () {
        subscription.cancel();
        controller.dispose();
      };
    }, [controller]);

    const border = OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(40)));

    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          IconButtonTheme(
            data: IconButtonThemeData(style: IconButton.styleFrom()),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MessageFieldIcons(
                    onPressed: () async {},
                    icon: const Icon(Icons.drive_folder_upload_outlined)),
                MessageFieldIcons(
                    onPressed: () async {}, icon: const Icon(Icons.image)),
                MessageFieldIcons(
                    onPressed: () async {},
                    icon: const Icon(Icons.video_library_rounded)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 40,
                child: TextField(
                  onTap: () {},
                  onChanged: (value) {},
                  controller: controller,
                  onSubmitted: (value) async {},
                  cursorHeight: 20,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 20),
                      filled: true,
                      fillColor: const Color.fromARGB(70, 171, 172, 173),
                      border: border,
                      errorBorder: border,
                      hintText: 'Type Something',
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      enabledBorder: border,
                      focusedBorder: border,
                      disabledBorder: border),
                ),
              ),
            ),
          ),
          MessageFieldIcons(
              onPressed: () {},
              icon: const Icon(Icons.send, color: TColors.primary)),
        ],
      ),
    );
  }
}
