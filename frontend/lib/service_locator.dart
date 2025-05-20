import 'package:get_it/get_it.dart';
import 'custom/bottomNavigationBar.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<AppState>(AppState());
}
