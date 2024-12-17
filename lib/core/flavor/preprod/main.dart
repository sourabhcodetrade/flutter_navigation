import '../../../main.dart';
import '../../../utils/app_config.dart';

void main() {
  AppConfig.instance.setEnvironment(Environment.preProd);
  mainDelegate();
}
