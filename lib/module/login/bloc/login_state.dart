part of 'login_bloc.dart';

enum BaseStatusEnum { initial, inprogress, failure, success, noData }

class LoginState extends Equatable {
  const LoginState({
    this.registerRequest,
    this.baseStatusEnum = BaseStatusEnum.initial,
    this.errorMessage,
  });

  final RegisterRequest? registerRequest;
  final BaseStatusEnum baseStatusEnum;
  final String? errorMessage;

  const LoginState.initial() : this();

  LoginState copyWith({
    RegisterRequest? registerRequest,
    BaseStatusEnum? baseStatusEnum,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return LoginState(
      registerRequest: registerRequest ?? this.registerRequest,
      baseStatusEnum: baseStatusEnum ?? this.baseStatusEnum,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [registerRequest, baseStatusEnum, errorMessage];
}
