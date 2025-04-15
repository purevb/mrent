// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:mrent/model/fb_user_model.dart' as _i9;
import 'package:mrent/model/mongo_user_model.dart' as _i9;
import 'package:mrent/pages/add_property_pages/add_property_details.dart'
    as _i1;
import 'package:mrent/pages/naviagation_page.dart';
import 'package:mrent/pages/profile_page/pages/pages/my_properties.dart';
import 'package:mrent/pages/profile_page/pages/pages/notification_page/notification_page.dart'
    as _i2;
import 'package:mrent/pages/profile_page/pages/pages/order_page/orders_page.dart';
import 'package:mrent/pages/profile_page/pages/pages/payment_page/payment_page.dart'
    as _i3;
import 'package:mrent/pages/profile_page/pages/pages/personal_information_page/personal_information_page.dart'
    as _i4;
import 'package:mrent/pages/profile_page/pages/pages/privacy_page/privacy_page.dart'
    as _i5;
import 'package:mrent/pages/profile_page/profile_page.dart' as _i6;

/// generated route for
/// [_i1.AddPropertyDetailsPage]
class AddPropertyDetailsRoute
    extends _i7.PageRouteInfo<AddPropertyDetailsRouteArgs> {
  AddPropertyDetailsRoute({
    required String id,
    required String name,
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          AddPropertyDetailsRoute.name,
          args: AddPropertyDetailsRouteArgs(id: id, name: name, key: key),
          initialChildren: children,
        );

  static const String name = 'AddPropertyDetailsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddPropertyDetailsRouteArgs>();
      return _i1.AddPropertyDetailsPage(
        id: args.id,
        name: args.name,
        key: args.key,
      );
    },
  );
}

class AddPropertyDetailsRouteArgs {
  const AddPropertyDetailsRouteArgs({
    required this.id,
    required this.name,
    this.key,
  });

  final String id;

  final String name;

  final _i8.Key? key;

  @override
  String toString() {
    return 'AddPropertyDetailsRouteArgs{id: $id, name: $name, key: $key}';
  }
}

class MessageCheckerArgs {
  const MessageCheckerArgs({this.user, this.key});

  final _i9.FbUserModel? user;

  final _i8.Key? key;

  @override
  String toString() {
    return 'MessageCheckerArgs{user: $user, key: $key}';
  }
}

/// generated route for
/// [MyPropertiesPage]
class MyPropertiesRoute extends _i7.PageRouteInfo<void> {
  const MyPropertiesRoute({List<_i7.PageRouteInfo>? children})
      : super(MyPropertiesRoute.name, initialChildren: children);

  static const String name = 'MyPropertiesRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const MyPropertiesPage();
    },
  );
}

/// generated route for
/// [NavigationPage]
class NavigationRoute extends _i7.PageRouteInfo<NavigationRouteArgs> {
  NavigationRoute({String? id, _i8.Key? key, List<_i7.PageRouteInfo>? children})
      : super(
          NavigationRoute.name,
          args: NavigationRouteArgs(id: id, key: key),
          initialChildren: children,
        );

  static const String name = 'NavigationRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NavigationRouteArgs>(
        orElse: () => const NavigationRouteArgs(),
      );
      return NavigationPage(id: args.id, key: args.key);
    },
  );
}

class NavigationRouteArgs {
  const NavigationRouteArgs({this.id, this.key});

  final String? id;

  final _i8.Key? key;

  @override
  String toString() {
    return 'NavigationRouteArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i2.NotificationPage]
class NotificationRoute extends _i7.PageRouteInfo<void> {
  const NotificationRoute({List<_i7.PageRouteInfo>? children})
      : super(NotificationRoute.name, initialChildren: children);

  static const String name = 'NotificationRoute';
  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.NotificationPage();
    },
  );
}

/// generated route for
/// [OrdersPage]
class OrdersRoute extends _i7.PageRouteInfo<void> {
  const OrdersRoute({List<_i7.PageRouteInfo>? children})
      : super(OrdersRoute.name, initialChildren: children);

  static const String name = 'OrdersRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const OrdersPage();
    },
  );
}

/// generated route for
/// [_i3.PaymentPage]
class PaymentRoute extends _i7.PageRouteInfo<void> {
  const PaymentRoute({List<_i7.PageRouteInfo>? children})
      : super(PaymentRoute.name, initialChildren: children);

  static const String name = 'PaymentRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.PaymentPage();
    },
  );
}

/// generated route for
/// [_i4.PersonalInformationPage]
class PersonalInformationRoute extends _i7.PageRouteInfo<void> {
  const PersonalInformationRoute({List<_i7.PageRouteInfo>? children})
      : super(PersonalInformationRoute.name, initialChildren: children);

  static const String name = 'PersonalInformationRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.PersonalInformationPage();
    },
  );
}

/// generated route for
/// [_i5.PrivacyPage]
class PrivacyRoute extends _i7.PageRouteInfo<void> {
  const PrivacyRoute({List<_i7.PageRouteInfo>? children})
      : super(PrivacyRoute.name, initialChildren: children);

  static const String name = 'PrivacyRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.PrivacyPage();
    },
  );
}

/// generated route for
/// [_i6.ProfilePage]
class ProfileRoute extends _i7.PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    required _i9.MongoUserModel user,
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          ProfileRoute.name,
          args: ProfileRouteArgs(user: user, key: key),
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileRouteArgs>();
      return _i6.ProfilePage(user: args.user, key: args.key);
    },
  );
}

class ProfileRouteArgs {
  const ProfileRouteArgs({required this.user, this.key});

  final _i9.MongoUserModel user;

  final _i8.Key? key;

  @override
  String toString() {
    return 'ProfileRouteArgs{user: $user, key: $key}';
  }
}
