import 'package:chat/src/chat/presentation/chat_bloc/chat_bloc.dart';
import 'package:chat/src/chat/presentation/widgets/chat_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/chat/presentation/widgets/app_bar.dart';
import 'package:chat/src/chat/presentation/widgets/message_field.dart';
import 'package:chat/src/chat/presentation/widgets/profile_image.dart';
import 'package:chat/utils/dateformat/date_formatter.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({
    super.key,
    required this.user,
    required this.currentUser,
  });
  final User user;
  final User currentUser;

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  @override
  void initState() {
    context.read<ChatBloc>().add(UpdateReadStatus(
          chatId: widget.user.id,
          userId: widget.currentUser.id,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ChatBody(
              user: widget.user,
              currentUser: widget.currentUser,
            ),
          ),
          const MessageField(),
        ],
      ),
      appBar: TAppBar(
        showLeading: true,
        toolbarHeight: 80.h,
        leadingWidth: screenSize.width * 0.5,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            ProfileImage(
              height: 40,
              width: 40,
              fit: BoxFit.cover,
              showActive: widget.user.showOnlineStatus,
              image: widget.user.profileImage,
              isNetwork: true,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      widget.user.name.split(' ').first,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  if (widget.user.showOnlineStatus) const Text('online'),
                  if (!widget.user.showOnlineStatus)
                    Text(
                      DateFormatter.format(widget.user.lastActive),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum SeparatorFrequency { days, hours }
