import '../../../main.dart';
import '../../../utils/constants/app_config.dart';

void main() {
  AppConfig().setEnvironment(Environment.stage);
  mainDelegate();
}
