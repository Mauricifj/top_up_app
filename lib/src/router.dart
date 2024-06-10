import 'package:go_router/go_router.dart';

import 'auth/domain/auth_service.dart';
import 'auth/presentation/login_page.dart';
import 'bank_account/domain/account_service.dart';
import 'bank_account/domain/transaction_type.dart';
import 'bank_account/presentation/transaction_page.dart';
import 'dependency_injection.dart';
import 'home/home_page.dart';
import 'profile/profile_page.dart';
import 'top_up/domain/beneficiary.dart';
import 'top_up/domain/beneficiary_service.dart';
import 'top_up/domain/top_up_service.dart';
import 'top_up/presentation/add_beneficiary_page.dart';
import 'top_up/presentation/details_beneficiary_page.dart';
import 'top_up/presentation/edit_beneficiary_page.dart';
import 'top_up/presentation/top_up_page.dart';
import 'top_up/presentation/top_ups_page.dart';

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
        GoRoute(
          path: TopUpsPage.path,
          builder: (context, state) {
            return TopUpsPage(
              beneficiaryService: serviceLocator<BeneficiaryService>(),
              topUpService: serviceLocator<TopUpService>(),
            );
          },
          routes: [
            GoRoute(
              path: AddBeneficiaryPage.path,
              builder: (context, state) {
                return AddBeneficiaryPage(
                  id: state.extra as String?,
                  beneficiaryService: serviceLocator<BeneficiaryService>(),
                );
              },
            ),
            GoRoute(
              path: DetailsBeneficiaryPage.path,
              builder: (context, state) {
                return DetailsBeneficiaryPage(
                  beneficiary: state.extra as Beneficiary,
                );
              },
            ),
            GoRoute(
              path: EditBeneficiaryPage.path,
              builder: (context, state) {
                return EditBeneficiaryPage(
                  beneficiary: state.extra as Beneficiary,
                  beneficiaryService: serviceLocator<BeneficiaryService>(),
                );
              },
            ),
            GoRoute(
              path: TopUpPage.path,
              builder: (context, state) {
                return TopUpPage(
                  beneficiary: state.extra as Beneficiary,
                  topUpService: serviceLocator<TopUpService>(),
                  accountService: serviceLocator<AccountService>(),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
