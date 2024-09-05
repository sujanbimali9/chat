import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/chat/presentation/widgets/profile_image.dart';
import 'package:chat/utils/color/color.dart';
import 'package:flutter/material.dart';

class UserDetail extends StatelessWidget {
  const UserDetail({
    super.key,
    required this.user,
  });
  final User user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: ProfileImage(
            width: 100,
            fit: BoxFit.cover,
            isNetwork: true,
            showActive: user.isOnline,
            image: user.profileImage,
            height: 100,
          )),
          const SizedBox(height: 10),
          Text(
            user.userName,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 4),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                backgroundColor: TColors.primary.withOpacity(0.7)),
            child: const Text('View Profile'),
          )
        ],
      ),
    );
  }
}
