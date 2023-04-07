// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final User? user;
  final LoginStatus? status;

  const AuthState({
    this.user,
    this.status,
  });

  @override
  List<Object> get props => [
        if (user != null) user!,
        if (status != null) status!,
      ];

  AuthState copyWith({
    User? user,
    LoginStatus? status,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}
