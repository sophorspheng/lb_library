part of 'app_route.dart';

Page<void> _loginPageBuilder(BuildContext context, GoRouterState state) {
  return const MaterialPage<void>(child: LoginPage());
}

Page<void> _signupPageBuilder(BuildContext context, GoRouterState state) {
  return const MaterialPage<void>(child: SignupPage());
}

Page<void> _homePageBuilder(BuildContext context, GoRouterState state) {
  return const MaterialPage<void>(child: HomePage());
}

Page<void> _bookViewDetailBuilder(BuildContext context, GoRouterState state) {
  final book = state.extra;
  if (book is! GetBookList) {
    return const MaterialPage<void>(
      child: Scaffold(
        body: SafeArea(
          child: Center(child: Text('Book details are unavailable.')),
        ),
      ),
    );
  }

  return MaterialPage<void>(child: BookViewDetail(book: book));
}
