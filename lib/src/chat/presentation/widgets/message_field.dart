import 'dart:async';
import 'dart:developer';

import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/chat/presentation/bloc/chat_bloc.dart';
import 'package:chat/src/chat/presentation/widgets/message_field_icon.dart';
import 'package:chat/utils/color/color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageField extends StatefulWidget {
  const MessageField({
    super.key,
    required this.user,
    required this.currentUser,
  });

  final User user;
  final User currentUser;

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  late final TextEditingController controller;
  late final StreamSubscription<bool> subscription;

  @override
  void initState() {
    controller = TextEditingController();
    subscription = KeyboardVisibilityController().onChange.listen((visible) {});
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    controller.dispose();
    super.dispose();
  }

  final border = const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(40)));
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
          final result = await picker.pickFiles(
              type: FileType.video, allowMultiple: false);
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
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () async {
                      final path = await pickFile(FileType.any);
                      if (!context.mounted) return;
                      if (path != null) {
                        context.read<ChatBloc>().add(SendFileEvent(path));
                      }
                    },
                    icon: const Icon(Icons.drive_folder_upload_outlined)),
                MessageFieldIcons(
                    onPressed: () async {
                      final path = await pickFile(FileType.image);
                      if (!context.mounted) return;
                      if (path != null) {
                        context.read<ChatBloc>().add(SendImageEvent(path));
                      }
                    },
                    icon: const Icon(Icons.image)),
                MessageFieldIcons(
                    onPressed: () async {
                      final path = await pickFile(FileType.video);
                      if (!context.mounted) return;
                      if (path != null) {
                        context.read<ChatBloc>().add(SendVideoEvent(path));
                      }
                    },
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
                  controller: controller,
                  onSubmitted: (value) async {
                    if (controller.text.isEmpty) return;
                    context
                        .read<ChatBloc>()
                        .add(SendTextEvent(controller.text));
                    controller.clear();
                  },
                  cursorHeight: 20,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                    filled: true,
                    fillColor: const Color.fromARGB(70, 171, 172, 173),
                    border: border,
                    errorBorder: border,
                    hintText: 'Type Something',
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    enabledBorder: border,
                    focusedBorder: border,
                    disabledBorder: border,
                  ),
                ),
              ),
            ),
          ),
          MessageFieldIcons(
              onPressed: () {
                if (controller.text.isEmpty) return;
                context.read<ChatBloc>().add(SendTextEvent(controller.text));
                controller.clear();
              },
              icon: const Icon(Icons.send, color: TColors.primary)),
        ],
      ),
    );
  }
}
