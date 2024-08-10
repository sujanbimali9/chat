import 'package:chat/src/auth/data/datasource/auth_remote_datasource.dart';
import 'package:chat/src/auth/data/repository/auth_repository_imp.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';
import 'package:chat/src/auth/domain/usecases/current_user.dart';
import 'package:chat/src/auth/domain/usecases/email_and_password_login.dart';
import 'package:chat/src/auth/domain/usecases/facebook_login.dart';
import 'package:chat/src/auth/domain/usecases/forget_password.dart';
import 'package:chat/src/auth/domain/usecases/gmail_login.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/auth/domain/usecases/resend_reset_email.dart';
import 'package:chat/src/auth/domain/usecases/resend_verify_email.dart';
import 'package:chat/src/auth/domain/usecases/signup.dart';
import 'package:chat/src/auth/domain/usecases/user_logged_in.dart';
import 'package:chat/src/auth/domain/usecases/verify_email.dart';
import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/cubit/hide_password_login/hide_password_cubit.dart';
import 'package:chat/src/chat/data/data_source/chat_remote_data_source.dart';
import 'package:chat/src/chat/data/repository/chat_repository_imp.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:chat/src/chat/domain/usecase/send_audio.dart';
import 'package:chat/src/chat/domain/usecase/send_file.dart';
import 'package:chat/src/chat/domain/usecase/send_image.dart';
import 'package:chat/src/chat/domain/usecase/send_text.dart';
import 'package:chat/src/chat/domain/usecase/send_video.dart';
import 'package:chat/src/home/data/datasource/home_remote_data_source.dart';
import 'package:chat/src/home/data/repository/home_repository_imp.dart';
import 'package:chat/src/home/domain/repository/home_repository.dart';
import 'package:chat/src/home/domain/usecases/create_user.dart';
import 'package:chat/src/home/domain/usecases/delete_user.dart';
import 'package:chat/src/home/domain/usecases/get_all_user.dart';
import 'package:chat/src/home/domain/usecases/get_current_user.dart';
import 'package:chat/src/home/domain/usecases/get_user_by_id.dart';
import 'package:chat/src/home/domain/usecases/search_user.dart';
import 'package:chat/src/home/domain/usecases/update_profile_image.dart';
import 'package:chat/src/home/domain/usecases/update_show_online_status.dart';
import 'package:chat/src/home/domain/usecases/update_user.dart';
import 'package:chat/src/home/presentation/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocater = GetIt.instance;

void initDependency() {
  serviceLocater.registerLazySingleton(() => Supabase.instance);
  serviceLocater
        ..registerFactory<AuthRemoteDataSource>(
            () => AuthRemoteDataSourceImp(serviceLocater()))
        ..registerFactory<AuthRepository>(
            () => AuthRepositoryImp(serviceLocater()))
        ..registerFactory(() => CurrentUserUseCase(serviceLocater()))
        ..registerFactory(() => EmailAndPasswordLoginUseCase(serviceLocater()))
        ..registerFactory(() => LoginWithFacebookUseCase(serviceLocater()))
        ..registerFactory(() => ForgetPasswordUseCase(serviceLocater()))
        ..registerFactory(() => LoginWithGmailUseCase(serviceLocater()))
        ..registerFactory(() => LogOutUseCase(serviceLocater()))
        ..registerFactory(() => ResendResetEmailUseCase(serviceLocater()))
        ..registerFactory(() => ResendVerifyEmailUseCase(serviceLocater()))
        ..registerFactory(() => SignUpUseCase(serviceLocater()))
        ..registerFactory(() => UserLoggedInUseCase(serviceLocater()))
        ..registerFactory(() => EmailVerifiedUseCase(serviceLocater()))
        ..registerFactory(() => AuthBloc(
              serviceLocater(),
              serviceLocater(),
              serviceLocater(),
              serviceLocater(),
              serviceLocater(),
              serviceLocater(),
              serviceLocater(),
              serviceLocater(),
              serviceLocater(),
              serviceLocater(),
              serviceLocater(),
            ))
        ..registerFactory(() => HidePasswordLoginCubit())
        ..registerFactory<HomeRemoteDataSource>(
            () => HomeRemoteDataSourceImpl(serviceLocater()))
        ..registerFactory<HomeRepository>(
            () => HomeRepositoryImp(serviceLocater()))
        ..registerFactory(() => CreateUserUseCase(serviceLocater()))
        ..registerFactory(() => DeleteUserUseCase(serviceLocater()))
        ..registerFactory(() => GetAllUserUseCase(serviceLocater()))
        ..registerFactory(() => GetCurrentUserUseCase(serviceLocater()))
        ..registerFactory(() => GetUserByIdUseCase(serviceLocater()))
        ..registerFactory(() => SearchUserUseCase(serviceLocater()))
        ..registerFactory(() => UpdateProfileImageUseCase(serviceLocater()))
        ..registerFactory(() => UpdateShowOnlineStatusUseCase(serviceLocater()))
        ..registerFactory(() => UpdateUserUseCase(serviceLocater()))
        ..registerFactory(
          () => HomeBloc(
            serviceLocater(),
            serviceLocater(),
            serviceLocater(),
            serviceLocater(),
            serviceLocater(),
            serviceLocater(),
            serviceLocater(),
            serviceLocater(),
          ),
        )
        ..registerFactory<ChatRemoteDataSource>(() => ChatRemoteDataSourceImp())
        ..registerFactory<ChatRepository>(
            () => ChatRepositoryImp(serviceLocater()))
        ..registerFactory(() => SendVideoUseCase(serviceLocater()))
        ..registerFactory(() => SendAudioUseCase(serviceLocater()))
        ..registerFactory(() => SendTextUseCase(serviceLocater()))
        ..registerFactory(() => SendFileUseCase(serviceLocater()))
        ..registerFactory(() => SendImageUseCase(serviceLocater()))
      //
      ;
}
