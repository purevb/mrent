import 'package:auto_route/auto_route.dart';
import 'package:mrent/route/route.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: NavigationRoute.page, initial: true),
      ];
}
