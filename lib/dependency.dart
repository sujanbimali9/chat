import 'package:chat/src/auth/data/datasource/auth_local_datasource.dart';
import 'package:chat/src/auth/data/datasource/auth_remote_datasource.dart';
import 'package:chat/src/auth/data/repository/auth_repository_imp.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';
import 'package:chat/src/auth/domain/usecases/email_and_password_login.dart';
import 'package:chat/src/auth/domain/usecases/facebook_login.dart';
import 'package:chat/src/auth/domain/usecases/forget_password.dart';
import 'package:chat/src/auth/domain/usecases/gmail_login.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/auth/domain/usecases/signup.dart';
import 'package:chat/src/auth/domain/usecases/user_logged_in.dart';
import 'package:chat/src/auth/domain/usecases/verify_email.dart';
import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/chat/data/data_source/chat_remote_data_source.dart';
import 'package:chat/src/chat/data/data_source/chat_local_data_source.dart';
import 'package:chat/src/chat/data/repository/chat_repository_imp.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:chat/src/chat/domain/usecase/get_chat.dart';
import 'package:chat/src/chat/domain/usecase/get_chat_stream.dart';
import 'package:chat/src/chat/domain/usecase/get_pending_chat.dart';
import 'package:chat/src/chat/domain/usecase/remove_chat.dart';
import 'package:chat/src/chat/domain/usecase/send_message.dart';
import 'package:chat/src/chat/presentation/bloc/pending_chat_bloc/pending_chat_bloc.dart';
import 'package:chat/src/home/data/datasource/user_local_data_source.dart';
import 'package:chat/src/home/data/datasource/user_remote_data_source.dart';
import 'package:chat/src/home/data/repository/sync_chat_repository.dart';
import 'package:chat/src/home/data/repository/user_repository_imp.dart';
import 'package:chat/src/home/domain/repository/sync_chat_repository.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:chat/src/home/domain/usecases/get_interacted_user.dart';
import 'package:chat/src/home/domain/usecases/get_interactive_user_stream.dart';
import 'package:chat/src/home/domain/usecases/get_user.dart';
import 'package:chat/src/home/domain/usecases/get_user_local.dart';
import 'package:chat/src/home/domain/usecases/get_current_user.dart';
import 'package:chat/src/home/domain/usecases/search_user.dart';
import 'package:chat/src/home/domain/usecases/sync_chat.dart';

import 'package:chat/src/home/domain/usecases/update_profile_image.dart';
import 'package:chat/src/home/domain/usecases/update_user.dart';
import 'package:chat/src/home/presentation/bloc/all_user_bloc/all_user_bloc.dart';
import 'package:chat/src/home/presentation/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:chat/src/home/presentation/bloc/sync_chat/sync_chat_bloc.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:chat/utils/helper/network_info.dart';
import 'package:chat/utils/services/api_service.dart';
import 'package:chat/utils/services/socket_io.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final serviceLocater = GetIt.instance;

void initDependency() {
  serviceLocater.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocater.registerLazySingleton(() => ApiService.init(serviceLocater()));
  serviceLocater.registerFactory(() => Connectivity());
  serviceLocater.registerLazySingleton(() => NetworkInfo.instance);
  serviceLocater.registerLazySingleton(() => LocalDatabase());
  serviceLocater.registerLazySingleton(() => SocketIOService());

  _initAuth();
  _initUser();
  _initChat();
  _initSync();
}

void _initAuth() {
  serviceLocater
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImp(serviceLocater(), serviceLocater()),
    )
    ..registerFactory<AuthLocalDataSource>(
      () => AuthLocalDataSourceImp(serviceLocater()),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImp(serviceLocater(), serviceLocater()),
    )
    ..registerFactory(() => EmailAndPasswordLoginUseCase(serviceLocater()))
    ..registerFactory(() => LoginWithFacebookUseCase(serviceLocater()))
    ..registerFactory(() => ForgetPasswordUseCase(serviceLocater()))
    ..registerFactory(() => LoginWithGmailUseCase(serviceLocater()))
    ..registerFactory(() => LogOutUseCase(serviceLocater()))
    ..registerFactory(() => SignUpUseCase(serviceLocater()))
    ..registerFactory(() => UserLoggedInUseCase(serviceLocater()))
    ..registerFactory(() => EmailVerifiedUseCase(serviceLocater()))
    ..registerLazySingleton(
      () => AuthBloc(
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
      ),
    );
}

void _initUser() {
  serviceLocater
    ..registerFactory<UserRemoteDataSource>(
      () => UserRemoteDataSourceImp(serviceLocater()),
    )
    ..registerFactory<UserLocalDataSource>(
      () => UserLocalDataSourceImp(serviceLocater(), serviceLocater()),
    )
    ..registerFactory<UserRepository>(
      () => UserRepositoryImp(
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
      ),
    )
    ..registerFactory(() => GetAllUsersUseCase(serviceLocater()))
    ..registerFactory(
      () => GetConverstationHistoryUserUseCase(serviceLocater()),
    )
    ..registerFactory(
      () => GetConversationHistoryUseCaseStream(serviceLocater()),
    )
    ..registerFactory(() => GetCurrentUserUseCase(serviceLocater()))
    ..registerFactory(() => SearchUserUseCase(serviceLocater()))
    ..registerFactory(() => UpdateProfileImageUseCase(serviceLocater()))
    ..registerFactory(() => UpdateUserUseCase(serviceLocater()))
    ..registerFactory(() => GetAllUserLocalUseCase(serviceLocater()))
    ..registerFactory(
      () =>
          CurrentUserBloc(serviceLocater(), serviceLocater(), serviceLocater()),
    )
    ..registerFactory(
      () => UserBloc(serviceLocater(), serviceLocater(), serviceLocater()),
    );
}

void _initSync() {
  serviceLocater
    ..registerFactory<SyncChatRepository>(
      () => SyncChatRepositoryImp(serviceLocater(), serviceLocater()),
    )
    ..registerFactory(() => SyncChatUseCase(serviceLocater()))
    ..registerFactory(() => SyncChatBloc(serviceLocater()));
}

void _initChat() {
  serviceLocater
    ..registerFactory<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImp(serviceLocater(), serviceLocater()),
    )
    ..registerFactory<ChatLocalDataSource>(
      () => ChatLocalDataSourceImp(serviceLocater()),
    )
    ..registerFactory<ChatRepository>(
      () => ChatRepositoryImp(
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
      ),
    )
    ..registerFactory(() => GetChatStreamUseCase(serviceLocater()))
    ..registerFactory(() => GetChatUseCase(serviceLocater()))
    ..registerFactory(() => RemoveChatUseCase(serviceLocater()))
    ..registerFactory(() => SendChatUseCase(serviceLocater()))
    ..registerFactory(() => GetPendingChatUseCase(serviceLocater()))
    ..registerFactory(
      () =>
          PendingChatBloc(serviceLocater(), serviceLocater(), serviceLocater()),
    );
}
