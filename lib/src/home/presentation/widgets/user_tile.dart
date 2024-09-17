import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/src/home/presentation/bloc/home_bloc.dart';
import 'package:chat/src/home/presentation/widgets/profile_image.dart';
import 'package:chat/utils/constant/routes.dart';
import 'package:chat/utils/dateformat/date_formatter.dart';
import 'package:chat/utils/icons/assetsicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    this.lastChat,
    required this.user,
  });

  final User user;
  final Chat? lastChat;

  String get lastMessage {
    if (lastChat == null) {
      return '';
    }
    if (lastChat!.type.isText) {
      return lastChat!.msg;
    }
    return lastChat!.type.name;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        onTap: () {
          Navigator.of(context).pushNamed(Routes.chat, arguments: {
            'user': user,
            'currentUser': context.read<HomeBloc>().state.currentUser,
          });
        },
        trailing: Text(DateFormatter.format(user.lastActive)),
        title:
            Text(user.fullName, style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(lastChat?.msg ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium),
        leading: ProfileImage(
          showActive: user.showOnlineStatus,
          fit: BoxFit.cover,
          width: 40,
          isNetwork: user.profileImage.isNotEmpty,
          image: user.profileImage.isNotEmpty ? user.profileImage : TIcons.user,
          height: 40,
        ));
  }
}
