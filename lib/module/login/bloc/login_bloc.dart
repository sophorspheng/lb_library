import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lb_library/core/network/network_api.dart';
import 'package:lb_library/module/app/view/app_lb.dart';
import 'package:lb_library/module/login/model/register_request.dart';
import 'package:lb_library/module/login/service/login_service.dart';
import 'package:lb_library/widgets/flat_card.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<RegisterSubmitted>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
    RegisterSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    showLoading();
    emit(
      state.copyWith(
        baseStatusEnum: BaseStatusEnum.inprogress,
        clearErrorMessage: true,
      ),
    );

    try {
      await LoginService().registerUser(registerRequest: event.request);
      emit(
        state.copyWith(
          baseStatusEnum: BaseStatusEnum.success,
          clearErrorMessage: true,
        ),
      );
    } on NetworkException catch (error) {
      emit(
        state.copyWith(
          baseStatusEnum: BaseStatusEnum.failure,
          errorMessage: error.message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          baseStatusEnum: BaseStatusEnum.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}

void _closeLoading() {
  Navigator.of(ReadoraApp.context).pop();
}

Future<void> showLoading() async {
  await showDialog<void>(
    context: ReadoraApp.context,
    barrierDismissible: false,
    barrierColor: Colors.black26,
    builder: (context) => Center(
      child: SizedBox(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FlatCard(
              color: Colors.white,
              borderRadius: 12,
              child: SizedBox(
                height: 90,
                width: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/readora_logo.png',
                    width: 68,
                    height: 68,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SpinKitFadingCircle(color: Colors.grey, size: 80),
          ],
        ),
      ),
    ),
  );
}
