import 'package:get_it/get_it.dart';
import 'app/services/localstorage_service.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final instance = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(instance, signalsReady: true);
}