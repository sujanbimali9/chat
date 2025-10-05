import 'dart:async';

import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/src/chat/data/model/media_model.dart';
import 'package:chat/src/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat/src/chat/presentation/bloc/reply_cubit/reply_cubit.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:chat/src/chat/presentation/widgets/message_field_icon.dart';
import 'package:chat/utils/color/color.dart';

class MessageField extends StatefulWidget {
  const MessageField({super.key});

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  late final TextEditingController controller;
  late final FocusNode focusNode;

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  final border = const OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(Radius.circular(40)),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocConsumer<ReplyCubit, ReplyState>(
            listener: (context, state) {
              if (state is Replying) {
                focusNode.requestFocus();
              }
            },
            listenWhen: (previous, current) {
              return current is Replying || previous is ReplyInitial;
            },
            builder: (context, state) {
              return state is Replying
                  ? buildReplyingTo(context, state.chat)
                  : const SizedBox();
            },
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 7),
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
                          if (!context.mounted || path == null) return;

                          context.read<ChatBloc>().add(
                            SendChat(
                              '',
                              type: ChatType.media,
                              medias: path,
                              mediaType: MediaType.file,
                            ),
                          );
                        },
                        icon: const Icon(Icons.drive_folder_upload_outlined),
                      ),
                      MessageFieldIcons(
                        onPressed: () async {
                          final path = await pickFile(FileType.image);
                          if (!context.mounted || path == null) return;
                          context.read<ChatBloc>().add(
                            SendChat(
                              '',
                              type: ChatType.media,
                              medias: path,
                              mediaType: MediaType.image,
                            ),
                          );
                        },
                        icon: const Icon(Icons.image),
                      ),
                      MessageFieldIcons(
                        onPressed: () async {
                          final path = await pickFile(FileType.video);
                          if (!context.mounted || path == null) return;
                          context.read<ChatBloc>().add(
                            SendChat(
                              '',
                              type: ChatType.media,
                              medias: path,
                              mediaType: MediaType.video,
                            ),
                          );
                        },
                        icon: const Icon(Icons.video_library_rounded),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onSubmitted: (value) async {
                          context.read<ChatBloc>().add(
                            SendChat(controller.text, type: ChatType.text),
                          );
                          controller.clear();
                        },
                        cursorHeight: 20,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 20,
                          ),
                          filled: true,
                          hoverColor: Colors.transparent,
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
                    context.read<ChatBloc>().add(
                      SendChat(controller.text, type: ChatType.text),
                    );
                    controller.clear();
                  },
                  icon: const Icon(Icons.send, color: TColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildReplyingTo(BuildContext context, Chat chat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: const BoxDecoration(color: Color.fromARGB(255, 47, 48, 48)),
      child: Row(
        children: [
          const Icon(Icons.reply, color: TColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              chat.type != ChatType.text ? chat.type.name : chat.msg,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<ReplyCubit>().cancelReply();
            },
            icon: const Icon(Icons.close, color: TColors.primary),
          ),
        ],
      ),
    );
  }

  Future<bool> handlePermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      final result = await permission.request();
      return result.isGranted;
    }
  }

  Future<bool> checkPermission(FileType type) async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    if (deviceInfo is AndroidDeviceInfo && deviceInfo.version.sdkInt >= 32) {
      switch (type) {
        case FileType.image:
          return handlePermission(Permission.photos);
        case FileType.video:
          return handlePermission(Permission.videos);
        case FileType.audio:
          return handlePermission(Permission.audio);
        case FileType.any:
          return handlePermission(Permission.manageExternalStorage);
        default:
          return handlePermission(Permission.manageExternalStorage);
      }
    }
    return handlePermission(Permission.storage);
  }

  Future<List<String>?> pickFile(FileType type) async {
    final bool permission = await checkPermission(type);
    if (!permission) return null;
    try {
      final picker = FilePicker.platform;
      FilePickerResult? result = switch (type) {
        FileType.image => await picker.pickFiles(
          type: FileType.image,
          allowMultiple: true,
        ),
        FileType.video => await picker.pickFiles(
          type: FileType.video,
          allowMultiple: true,
        ),
        _ => await picker.pickFiles(allowMultiple: true),
      };
      if (result != null) {
        return result.paths.where((element) => element != null).toList().cast();
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
