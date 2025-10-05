import 'package:chat/src/chat/presentation/widgets/chat_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/chat/presentation/widgets/app_bar.dart';
import 'package:chat/src/chat/presentation/widgets/message_field.dart';
import 'package:chat/src/chat/presentation/widgets/profile_image.dart';
import 'package:chat/utils/dateformat/date_formatter.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.user, required this.currentUser});
  final User user;
  final User currentUser;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ChatBody(user: user, currentUser: currentUser),
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
              showActive: user.showOnlineStatus,
              image: user.profileImage,
              isNetwork: true,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      user.name.split(' ').first,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  if (user.showOnlineStatus) const Text('online'),
                  if (!user.showOnlineStatus)
                    Text(
                      DateFormatter.format(user.lastActive),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
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
