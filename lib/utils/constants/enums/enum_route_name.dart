abstract class Routes {
  String get routeName;
}

enum RootRouteName implements Routes {
  splashScreen,
  dashboard,
  loginScreen,
  home,
  paymentRouter;

  @override
  String get routeName => name;
}

enum PaymentRouteName implements Routes {
  payment1,
  payment2,
  payment3,
  payment4;

  @override
  String get routeName => name;
}
