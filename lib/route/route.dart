import 'package:auto_route/auto_route.dart';
import 'package:mrent/route/route.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: BeginningRoute.page, initial: true),
        AutoRoute(page: NavigationRoute.page),
        CupertinoRoute(
          page: LoginRoute.page,
          path: '/login',
        ),
        CupertinoRoute(
          page: RegisterRoute.page,
          path: '/register',
        ),
        // AutoRoute(page: MyHomeRoute.page),
        CupertinoRoute(
          page: MyHomeRoute.page,
          path: '/home',
        ),
        AutoRoute(page: DetailOfObjectRoute.page, path: '/detail-of-object'),
      ];
}
