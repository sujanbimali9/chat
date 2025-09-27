import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/home/domain/usecases/get_current_user.dart';
import 'package:chat/src/home/domain/usecases/update_profile_image.dart';
import 'package:chat/src/home/domain/usecases/update_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_user_event.dart';
part 'current_user_state.dart';
part 'current_user_bloc.freezed.dart';

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final UpdateProfileImageUseCase _updateImageUseCase;

  CurrentUserBloc(
    this._getCurrentUserUseCase,
    this._updateUserUseCase,
    this._updateImageUseCase,
  ) : super(const _Initial()) {
    on<CurrentUserEvent>((event, emit) async {
      await event.map<FutureOr<void>>(
        getCurrentUser: (e) => _getCurrentUser(emit, e),
        updateCurrentUser: (e) => _updateCurrentUser(emit, e),
        updateImage: (e) => _updateImage(emit, e),
      );
    });
    add(const CurrentUserEvent.getCurrentUser());
  }

  FutureOr<void> _getCurrentUser(
    Emitter<CurrentUserState> emit,
    _GetCurrentUser e,
  ) async {
    final currentUser = state.maybeWhen(
      orElse: () => null,
      loaded: (user) => user,
      imageUploading: (user) => user,
    );
    final localUser = await _getCurrentUserUseCase(
      const GetCurrentUserParams(local: true),
    );
    localUser.fold(
      (l) {
        emit(CurrentUserState.error(currentUser, l.message));
      },
      (r) {
        emit(CurrentUserState.loaded(r));
      },
    );

    final remoteUser = await _getCurrentUserUseCase(
      const GetCurrentUserParams(),
    );
    remoteUser.fold((l) {}, (r) {
      if (currentUser == null || currentUser.id != r.id) {
        emit(CurrentUserState.loaded(r));
      } else {
        emit(CurrentUserState.imageUploading(r));
      }
    });
  }

  FutureOr<void> _updateCurrentUser(
    Emitter<CurrentUserState> emit,
    _UpdateCurrentUser e,
  ) async {
    final currentUser = state.maybeWhen(
      orElse: () => null,
      loaded: (user) => user,
      imageUploading: (user) => user,
    );
    final result = await _updateUserUseCase(e.user);
    result.fold(
      (l) {
        emit(CurrentUserState.error(currentUser, l.message));
      },
      (r) {
        emit(CurrentUserState.loaded(r));
      },
    );
  }

  FutureOr<void> _updateImage(
    Emitter<CurrentUserState> emit,
    _UpdateImage e,
  ) async {
    final currentUser = state.maybeWhen(
      orElse: () => null,
      loaded: (user) => user,
    );
    if (currentUser == null) {
      emit(const CurrentUserState.error(null, 'User not loaded'));
      return;
    }
    emit(CurrentUserState.imageUploading(currentUser));
    final result = await _updateImageUseCase(File(e.image));
    result.fold(
      (l) {
        emit(CurrentUserState.error(currentUser, l.message));
      },
      (r) {
        emit(CurrentUserState.loaded(r));
      },
    );
  }
}
