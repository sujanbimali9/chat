import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/home/presentation/bloc/home_bloc.dart';
import 'package:chat/src/home/presentation/widgets/circular_container.dart';
import 'package:chat/src/home/presentation/widgets/profile_image.dart';
import 'package:chat/utils/icons/assetsicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentUserProfileImage extends StatelessWidget {
  const CurrentUserProfileImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, User?>(
      selector: (state) {
        return state.currentUser;
      },
      builder: (context, state) {
        if (state == null) {
          return TCircularContainer(
              borderRadius: 20.r,
              height: 40.h,
              width: 40.h,
              backgroundColor: Colors.grey);
        }
        return ProfileImage(
          onTap: () async {},
          height: 40.h,
          width: 40.h,
          borderRadius: 60,
          showActive: state.showOnlineStatus,
          isNetwork: state.profileImage.isNotEmpty,
          fit: BoxFit.cover,
          image:
              state.profileImage.isNotEmpty ? state.profileImage : TIcons.user,
        );
      },
    );
  }
}
