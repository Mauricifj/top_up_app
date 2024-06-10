import 'package:go_router/go_router.dart';

import 'auth/domain/auth_service.dart';
import 'auth/presentation/login_page.dart';
import 'bank_account/domain/account_service.dart';
import 'bank_account/domain/transaction_type.dart';
import 'bank_account/presentation/transaction_page.dart';
import 'dependency_injection.dart';
import 'home/home_page.dart';
import 'profile/profile_page.dart';

final GoRouter router = GoRouter(
  initialLocation: LoginPage.path,
  redirect: (context, state) {
    return serviceLocator<AuthService>().user == null ? LoginPage.path : null;
  },
  refreshListenable: serviceLocator<AuthService>(),
  routes: <RouteBase>[
    GoRoute(
      path: LoginPage.path,
      builder: (context, state) {
        return LoginPage(
          authService: serviceLocator<AuthService>(),
        );
      },
    ),
    GoRoute(
      path: HomePage.path,
      builder: (context, state) {
        return HomePage(
          authService: serviceLocator<AuthService>(),
          accountService: serviceLocator<AccountService>(),
        );
      },
      routes: [
        GoRoute(
          path: ProfilePage.path,
          builder: (context, state) {
            return ProfilePage(
              authService: serviceLocator<AuthService>(),
            );
          },
        ),
        GoRoute(
          path: TransactionPage.depositPath,
          builder: (context, state) {
            return TransactionPage(
              accountService: serviceLocator<AccountService>(),
              transactionType: TransactionType.deposit,
            );
          },
        ),
        GoRoute(
          path: TransactionPage.withdrawPath,
          builder: (context, state) {
            return TransactionPage(
              accountService: serviceLocator<AccountService>(),
              transactionType: TransactionType.withdrawal,
            );
          },
        ),
      ],
    ),
  ],
);
