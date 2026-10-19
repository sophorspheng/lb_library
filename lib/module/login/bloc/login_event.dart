part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class RegisterSubmitted extends LoginEvent {
  const RegisterSubmitted({required this.request});

  final RegisterRequest request;

  @override
  List<Object> get props => [request];
}
