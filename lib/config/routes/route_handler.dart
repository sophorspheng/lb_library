
part of 'app_route.dart';

Page<void> _loginPageBuilder(
  BuildContext context,
  GoRouterState state,
) {
  return const MaterialPage<void>(
    child: LoginPage(),
  );
}

Page<void> _signupPageBuilder(
  BuildContext context,
  GoRouterState state,
) {
  return const MaterialPage<void>(
    child: SignupPage(),
  );
}

Page<void> _homePageBuilder(
  BuildContext context,
  GoRouterState state,
) {
  return const MaterialPage<void>(
    child: HomePage(),
  );
}
