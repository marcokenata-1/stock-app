part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {}

class Loading extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class Unauthenticated extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];

}