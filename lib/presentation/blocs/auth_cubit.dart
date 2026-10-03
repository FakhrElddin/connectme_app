import 'package:bloc/bloc.dart';
import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/services/auth_service.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authService}) : super(AuthInitial());

  final AuthService authService;

  void signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(SignUpLoading());
    var either = await authService.signUpUser(
      emailAddress: email,
      password: password,
      name: name,
    );
    either.fold(
      (failure) => emit(SignUpFailure(failure: failure)),
      (userCredential) => emit(SignUpSuccess()),
    );
  }

  void loginUser({required String email, required String password}) async {
    emit(LoginLoading());
    var either = await authService.loginUser(
      emailAddress: email,
      password: password,
    );
    either.fold(
      (failure) => emit(LoginFailure(failure: failure)),
      (userCredential) => emit(LoginSuccess()),
    );
  }
}
