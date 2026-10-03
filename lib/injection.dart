import 'package:connectme_app/services/auth_service.dart';
import 'package:connectme_app/services/firestore_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void diInit() {
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService(),);
  getIt.registerLazySingleton<AuthService>(() => AuthService(),);
}