import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/home/domain/usecases/create_user.dart';
import 'package:chat/src/home/domain/usecases/delete_user.dart';
import 'package:chat/src/home/domain/usecases/get_all_user.dart';
import 'package:chat/src/home/domain/usecases/get_current_user.dart';
import 'package:chat/src/home/domain/usecases/get_user_by_id.dart';
import 'package:chat/src/home/domain/usecases/search_user.dart';
import 'package:chat/src/home/domain/usecases/update_profile_image.dart';
import 'package:chat/src/home/domain/usecases/update_show_online_status.dart';
import 'package:chat/src/home/domain/usecases/update_user.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAllUserUseCase _getAllUserUseCase;
  final GetUserByIdUseCase _getUserByIdUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SearchUserUseCase _searchUserUseCase;
  final CreateUserUseCase _createUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final UpdateProfileImageUseCase _updateImageUseCase;
  final UpdateShowOnlineStatusUseCase _updateShowOnlineStatusUseCase;

  HomeBloc(
    GetAllUserUseCase getAllUserUseCase,
    GetUserByIdUseCase getUserByIdUseCase,
    SearchUserUseCase searchUserUseCase,
    GetCurrentUserUseCase getCurrentUserUseCase,
    CreateUserUseCase createUserUseCase,
    UpdateUserUseCase updateUserUseCase,
    DeleteUserUseCase deleteUserUseCase,
    UpdateProfileImageUseCase updateImageUseCase,
    UpdateShowOnlineStatusUseCase updateShowOnlineStatusUseCase,
  )   : _getAllUserUseCase = getAllUserUseCase,
        _getUserByIdUseCase = getUserByIdUseCase,
        _searchUserUseCase = searchUserUseCase,
        _createUserUseCase = createUserUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _updateUserUseCase = updateUserUseCase,
        _deleteUserUseCase = deleteUserUseCase,
        _updateImageUseCase = updateImageUseCase,
        _updateShowOnlineStatusUseCase = updateShowOnlineStatusUseCase,
        super(const HomeState(users: {}, isLoading: true)) {
    on<GetUsersEvent>(_getUsers);
    on<CreateUser>(_createUser);
    on<GetCurrentUserEvent>(_getCurrentUser);
    on<DeleteUserEvent>(_deleteUser);
    on<UpdateUserEvent>(_updateUser);
    on<GetUserByIdEvent>(_getUserById);
    on<SearchUserEvent>(_searchUser);
    on<UpdateProfileImageEvent>(_updateImage);
    on<UpdateShowOnlineStatusEvent>(_updateShowOnlineStatus);
  }

  FutureOr<void> _getUsers(GetUsersEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result =
        await _getAllUserUseCase(GetUserParms(limit: 20, offset: 20));

    result.fold(
      (l) => emit(state.copyWith(isLoading: false)),
      (r) => emit(state.copyWith(users: r, isLoading: false)),
    );
  }

  FutureOr<void> _deleteUser(
      DeleteUserEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _deleteUserUseCase(event.id);

    result.fold(
      (l) => emit(state.copyWith(isLoading: false)),
      (r) {},
    );
  }

  FutureOr<void> _updateUser(UpdateUserEvent event, Emitter<HomeState> emit) {}

  FutureOr<void> _searchUser(SearchUserEvent event, Emitter<HomeState> emit) {}

  FutureOr<void> _updateImage(
      UpdateProfileImageEvent event, Emitter<HomeState> emit) {}

  FutureOr<void> _getUserById(
      GetUserByIdEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getUserByIdUseCase(event.id);
    result.fold(
      (l) => emit(state.copyWith(isLoading: false)),
      (r) => emit(state.copyWith(isLoading: false)),
    );
  }

  FutureOr<void> _updateShowOnlineStatus(
      UpdateShowOnlineStatusEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        currentUser:
            state.currentUser?.copyWith(isOnline: event.showOnlineStatus)));
    await _updateShowOnlineStatusUseCase(event.showOnlineStatus);
  }

  FutureOr<void> _createUser(CreateUser event, Emitter<HomeState> emit) async {
    final result = await _createUserUseCase(NoParams());
    result.fold(
      (l) => emit(state.copyWith(isLoading: false)),
      (r) => emit(state.copyWith(currentUser: r, isLoading: false)),
    );
  }

  FutureOr<void> _getCurrentUser(
      GetCurrentUserEvent event, Emitter<HomeState> emit) async {
    final result = await _getCurrentUserUseCase(NoParams());
    result.fold(
      (l) => emit(state.copyWith(isLoading: false)),
      (r) => emit(state.copyWith(currentUser: r, isLoading: false)),
    );
  }
}
