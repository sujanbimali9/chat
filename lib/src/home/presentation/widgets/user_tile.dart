import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/home/presentation/widgets/profile_image.dart';
import 'package:chat/utils/dateformat/date_formatter.dart';
import 'package:chat/utils/icons/assetsicons.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        onTap: () async {
          if (!context.mounted) {
            return;
          }
        },
        trailing:
            user.isOnline ? Text(DateFormatter.format(user.lastActive)) : null,
        // subtitle: Consumer(
        //   builder: (context, ref, child) => ref
        //       .watch(getLastChatsProvider(id: user.id))
        //       .when<Widget>(
        //         data: (data) => Text(
        //             data.type == MessageType.text.name ? data.msg : data.type,
        //             style: Theme.of(context).textTheme.bodySmall),
        //         error: (error, _) => const SizedBox(),
        //         loading: () => const SizedBox(),
        //       ),
        // ),
        title:
            Text(user.fullName, style: Theme.of(context).textTheme.bodyLarge),
        leading: ProfileImage(
          showActive: user.isOnline && user.showOnlineStatus,
          fit: BoxFit.cover,
          width: 40,
          isNetwork: user.profileImage.isNotEmpty,
          image: user.profileImage.isNotEmpty ? user.profileImage : TIcons.user,
          height: 40,
        ));
  }
}
