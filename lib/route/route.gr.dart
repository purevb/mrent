// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:flutter/material.dart' as _i13;
import 'package:mrent/model/properties.dart' as _i12;
import 'package:mrent/pages/beginning_page.dart' as _i1;
import 'package:mrent/pages/detail_of_object_page.dart' as _i2;
import 'package:mrent/pages/favorite_page.dart' as _i3;
import 'package:mrent/pages/home_page.dart' as _i5;
import 'package:mrent/pages/login_page.dart' as _i4;
import 'package:mrent/pages/naviagation_page.dart' as _i6;
import 'package:mrent/pages/payment_page.dart' as _i7;
import 'package:mrent/pages/profile_page.dart' as _i8;
import 'package:mrent/pages/register_page.dart' as _i9;
import 'package:mrent/pages/search_page.dart' as _i10;

/// generated route for
/// [_i1.BeginningPage]
class BeginningRoute extends _i11.PageRouteInfo<void> {
  const BeginningRoute({List<_i11.PageRouteInfo>? children})
      : super(
          BeginningRoute.name,
          initialChildren: children,
        );

  static const String name = 'BeginningRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i1.BeginningPage();
    },
  );
}

/// generated route for
/// [_i2.DetailOfObjectPage]
class DetailOfObjectRoute extends _i11.PageRouteInfo<DetailOfObjectRouteArgs> {
  DetailOfObjectRoute({
    required _i12.PropertyData propertyData,
    _i13.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          DetailOfObjectRoute.name,
          args: DetailOfObjectRouteArgs(
            propertyData: propertyData,
          ),
          initialChildren: children,
        );

  static const String name = 'DetailOfObjectRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DetailOfObjectRouteArgs>();
      return _i2.DetailOfObjectPage(
        propertyData: args.propertyData,
      );
    },
  );
}

class DetailOfObjectRouteArgs {
  const DetailOfObjectRouteArgs({
    required this.propertyData,
  });

  final _i12.PropertyData propertyData;

  @override
  String toString() {
    return 'DetailOfObjectRouteArgs{propertyData: $propertyData}';
  }
}

/// generated route for
/// [_i3.FavoritePage]
class FavoriteRoute extends _i11.PageRouteInfo<void> {
  const FavoriteRoute({List<_i11.PageRouteInfo>? children})
      : super(
          FavoriteRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavoriteRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i3.FavoritePage();
    },
  );
}

/// generated route for
/// [_i4.LoginPage]
class LoginRoute extends _i11.PageRouteInfo<void> {
  const LoginRoute({List<_i11.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i4.LoginPage();
    },
  );
}

/// generated route for
/// [_i5.MyHomePage]
class MyHomeRoute extends _i11.PageRouteInfo<MyHomeRouteArgs> {
  MyHomeRoute({
    _i13.Key? key,
    String? id,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          MyHomeRoute.name,
          args: MyHomeRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'MyHomeRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<MyHomeRouteArgs>(orElse: () => const MyHomeRouteArgs());
      return _i5.MyHomePage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class MyHomeRouteArgs {
  const MyHomeRouteArgs({
    this.key,
    this.id,
  });

  final _i13.Key? key;

  final String? id;

  @override
  String toString() {
    return 'MyHomeRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i6.NavigationPage]
class NavigationRoute extends _i11.PageRouteInfo<NavigationRouteArgs> {
  NavigationRoute({
    required String id,
    _i13.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          NavigationRoute.name,
          args: NavigationRouteArgs(
            id: id,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'NavigationRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NavigationRouteArgs>();
      return _i6.NavigationPage(
        id: args.id,
        key: args.key,
      );
    },
  );
}

class NavigationRouteArgs {
  const NavigationRouteArgs({
    required this.id,
    this.key,
  });

  final String id;

  final _i13.Key? key;

  @override
  String toString() {
    return 'NavigationRouteArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i7.PaymentPage]
class PaymentRoute extends _i11.PageRouteInfo<void> {
  const PaymentRoute({List<_i11.PageRouteInfo>? children})
      : super(
          PaymentRoute.name,
          initialChildren: children,
        );

  static const String name = 'PaymentRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i7.PaymentPage();
    },
  );
}

/// generated route for
/// [_i8.ProfilePage]
class ProfileRoute extends _i11.PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    required String id,
    _i13.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          ProfileRoute.name,
          args: ProfileRouteArgs(
            id: id,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileRouteArgs>();
      return _i8.ProfilePage(
        id: args.id,
        key: args.key,
      );
    },
  );
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    required this.id,
    this.key,
  });

  final String id;

  final _i13.Key? key;

  @override
  String toString() {
    return 'ProfileRouteArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i9.RegisterPage]
class RegisterRoute extends _i11.PageRouteInfo<void> {
  const RegisterRoute({List<_i11.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i9.RegisterPage();
    },
  );
}

/// generated route for
/// [_i10.RentalSearchPage]
class RentalSearchRoute extends _i11.PageRouteInfo<void> {
  const RentalSearchRoute({List<_i11.PageRouteInfo>? children})
      : super(
          RentalSearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'RentalSearchRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i10.RentalSearchPage();
    },
  );
}
