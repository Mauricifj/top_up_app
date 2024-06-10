import 'package:get_it/get_it.dart';

import 'auth/data/auth_service_impl.dart';
import 'auth/domain/auth_service.dart';
import 'bank_account/data/account_service_impl.dart';
import 'bank_account/domain/account_service.dart';

final serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(),
  );

  serviceLocator.registerLazySingleton<AccountService>(
    () => AccountServiceImpl(),
  );
}
