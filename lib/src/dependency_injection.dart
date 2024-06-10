import 'package:get_it/get_it.dart';

import 'auth/data/auth_service_impl.dart';
import 'auth/domain/auth_service.dart';
import 'bank_account/data/account_service_impl.dart';
import 'bank_account/domain/account_service.dart';
import 'top_up/data/beneficiary_service_impl.dart';
import 'top_up/data/top_up_service_impl.dart';
import 'top_up/domain/beneficiary_service.dart';
import 'top_up/domain/top_up_service.dart';

final serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(),
  );

  serviceLocator.registerLazySingleton<AccountService>(
    () => AccountServiceImpl(),
  );

  serviceLocator.registerLazySingleton<BeneficiaryService>(
    () => BeneficiaryServiceImpl(),
  );

  serviceLocator.registerLazySingleton<TopUpService>(
    () => TopUpServiceImpl(
      accountService: serviceLocator(),
      authService: serviceLocator(),
    ),
  );
}
