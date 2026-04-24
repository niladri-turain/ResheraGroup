import 'package:get_it/get_it.dart';
import '../constants/api_end_points.dart';
import '../service/api_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton(() => ApiService(baseUrl: ApiEndPoints.baseUrl));
}
