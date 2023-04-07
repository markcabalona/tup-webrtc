// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:tuplive/features/Auth/domain/entities/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void login() async {
    final fbAuth = FacebookAuth.instance;
    final result = await fbAuth.login();
    if (result.status == LoginStatus.success) {
      emit(
        state.copyWith(
          status: result.status,
          user: User.fromFBAuth(await fbAuth.getUserData()),
        ),
      );
    } else {
      emit(
        state.copyWith(status: result.status),
      );
    }
  }

  void logout() async {
    final fbAuth = FacebookAuth.instance;
    await fbAuth.logOut();
    emit(const AuthState());
  }
}
