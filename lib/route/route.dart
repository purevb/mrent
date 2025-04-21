import 'package:auto_route/auto_route.dart';
import 'package:mrent/route/route.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: NavigationRoute.page, initial: true),
        // CupertinoRoute(
        //     page: PersonalInformationRoute.page, path: '/personal_information'),
        CupertinoRoute(page: PaymentRoute.page, path: '/payment'),
        CupertinoRoute(page: NotificationRoute.page, path: '/noti'),
        CupertinoRoute(page: PrivacyRoute.page, path: '/privacy'),
        CupertinoRoute(
            page: AddPropertyDetailsRoute.page, path: '/add_property'),
        // CupertinoRoute(page: MyPropertiesRoute.page, path: '/my_properties'),
        CupertinoRoute(page: OrdersRoute.page, path: '/orders'),
      ];
}
