import 'package:get_it/get_it.dart';
import 'package:whatshapp_clone/core/services/auth_service.dart';
import 'package:whatshapp_clone/core/services/chat_service.dart';
import 'package:whatshapp_clone/viewModels/chart_model.dart';
import 'package:whatshapp_clone/viewModels/sign_in_view.dart';

GetIt getIt = GetIt.instance;
setUpLocaters() {
  getIt.registerLazySingleton(() => ChatService());
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerFactory(() => ChartModel());
  getIt.registerFactory(() => SignInModel());
}
