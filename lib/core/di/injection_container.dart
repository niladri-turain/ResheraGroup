import 'package:get_it/get_it.dart';
import '../../features/login/provider/login_provider.dart';
import '../../features/login/provider/user_address_provider.dart';
import '../constants/api_end_points.dart';
import '../service/api_service.dart';
import '../service/shared_pref_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton(() => ApiService(baseUrl: ApiEndPoints.baseUrl));
  sl.registerLazySingleton(() => SharedPrefService());

  // Providers
  sl.registerLazySingleton(() => LoginProvider());
  sl.registerLazySingleton(() => UserAddressProvider());
}
