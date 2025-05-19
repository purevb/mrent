// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:flutter/material.dart' as _i12;
import 'package:mrent/model/mongo_user_model.dart' as _i13;
import 'package:mrent/model/order_model.dart' as _i15;
import 'package:mrent/model/property_model.dart' as _i14;
import 'package:mrent/pages/add_property_pages/add_property_details.dart'
    as _i1;
import 'package:mrent/pages/naviagation_page.dart' as _i4;
import 'package:mrent/pages/profile_page/pages/pages/earning_page/earning_page.dart'
    as _i2;
import 'package:mrent/pages/profile_page/pages/pages/my_properties.dart' as _i3;
import 'package:mrent/pages/profile_page/pages/pages/notification_page/notification_page.dart'
    as _i5;
import 'package:mrent/pages/profile_page/pages/pages/order_page/orders_page.dart'
    as _i6;
import 'package:mrent/pages/profile_page/pages/pages/personal_information_page/personal_information_page.dart'
    as _i7;
import 'package:mrent/pages/profile_page/pages/pages/privacy_page/privacy_page.dart'
    as _i8;
import 'package:mrent/pages/profile_page/profile_page.dart' as _i9;
import 'package:mrent/pages/rent_request_page/rent_req_page.dart' as _i10;

/// generated route for
/// [_i1.AddPropertyDetailsPage]
class AddPropertyDetailsRoute
    extends _i11.PageRouteInfo<AddPropertyDetailsRouteArgs> {
  AddPropertyDetailsRoute({
    required String id,
    required String name,
    _i12.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         AddPropertyDetailsRoute.name,
         args: AddPropertyDetailsRouteArgs(id: id, name: name, key: key),
         initialChildren: children,
       );

  static const String name = 'AddPropertyDetailsRoute';

  static _i11.PageInfo page = _i11.PageInfo(
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

  final _i12.Key? key;

  @override
  String toString() {
    return 'AddPropertyDetailsRouteArgs{id: $id, name: $name, key: $key}';
  }
}

/// generated route for
/// [_i2.EarningPage]
class EarningRoute extends _i11.PageRouteInfo<EarningRouteArgs> {
  EarningRoute({
    _i12.Key? key,
    required _i13.MongoUserModel user,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         EarningRoute.name,
         args: EarningRouteArgs(key: key, user: user),
         initialChildren: children,
       );

  static const String name = 'EarningRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EarningRouteArgs>();
      return _i2.EarningPage(key: args.key, user: args.user);
    },
  );
}

class EarningRouteArgs {
  const EarningRouteArgs({this.key, required this.user});

  final _i12.Key? key;

  final _i13.MongoUserModel user;

  @override
  String toString() {
    return 'EarningRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i3.MyPropertiesPage]
class MyPropertiesRoute extends _i11.PageRouteInfo<MyPropertiesRouteArgs> {
  MyPropertiesRoute({
    required List<_i14.PropertyModel> userPropertyDatas,
    _i12.Key? key,
    dynamic user,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         MyPropertiesRoute.name,
         args: MyPropertiesRouteArgs(
           userPropertyDatas: userPropertyDatas,
           key: key,
           user: user,
         ),
         initialChildren: children,
       );

  static const String name = 'MyPropertiesRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MyPropertiesRouteArgs>();
      return _i3.MyPropertiesPage(
        userPropertyDatas: args.userPropertyDatas,
        key: args.key,
        user: args.user,
      );
    },
  );
}

class MyPropertiesRouteArgs {
  const MyPropertiesRouteArgs({
    required this.userPropertyDatas,
    this.key,
    this.user,
  });

  final List<_i14.PropertyModel> userPropertyDatas;

  final _i12.Key? key;

  final dynamic user;

  @override
  String toString() {
    return 'MyPropertiesRouteArgs{userPropertyDatas: $userPropertyDatas, key: $key, user: $user}';
  }
}

/// generated route for
/// [_i4.NavigationPage]
class NavigationRoute extends _i11.PageRouteInfo<NavigationRouteArgs> {
  NavigationRoute({
    _i13.MongoUserModel? user,
    String? id,
    _i12.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         NavigationRoute.name,
         args: NavigationRouteArgs(user: user, id: id, key: key),
         initialChildren: children,
       );

  static const String name = 'NavigationRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NavigationRouteArgs>(
        orElse: () => const NavigationRouteArgs(),
      );
      return _i4.NavigationPage(user: args.user, id: args.id, key: args.key);
    },
  );
}

class NavigationRouteArgs {
  const NavigationRouteArgs({this.user, this.id, this.key});

  final _i13.MongoUserModel? user;

  final String? id;

  final _i12.Key? key;

  @override
  String toString() {
    return 'NavigationRouteArgs{user: $user, id: $id, key: $key}';
  }
}

/// generated route for
/// [_i5.NotificationPage]
class NotificationRoute extends _i11.PageRouteInfo<void> {
  const NotificationRoute({List<_i11.PageRouteInfo>? children})
    : super(NotificationRoute.name, initialChildren: children);

  static const String name = 'NotificationRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i5.NotificationPage();
    },
  );
}

/// generated route for
/// [_i6.OrdersPage]
class OrdersRoute extends _i11.PageRouteInfo<OrdersRouteArgs> {
  OrdersRoute({
    required List<_i15.BookingModel> orderData,
    _i12.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         OrdersRoute.name,
         args: OrdersRouteArgs(orderData: orderData, key: key),
         initialChildren: children,
       );

  static const String name = 'OrdersRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrdersRouteArgs>();
      return _i6.OrdersPage(orderData: args.orderData, key: args.key);
    },
  );
}

class OrdersRouteArgs {
  const OrdersRouteArgs({required this.orderData, this.key});

  final List<_i15.BookingModel> orderData;

  final _i12.Key? key;

  @override
  String toString() {
    return 'OrdersRouteArgs{orderData: $orderData, key: $key}';
  }
}

/// generated route for
/// [_i7.PersonalInformationPage]
class PersonalInformationRoute
    extends _i11.PageRouteInfo<PersonalInformationRouteArgs> {
  PersonalInformationRoute({
    required _i13.MongoUserModel mongoUser,
    _i12.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         PersonalInformationRoute.name,
         args: PersonalInformationRouteArgs(mongoUser: mongoUser, key: key),
         initialChildren: children,
       );

  static const String name = 'PersonalInformationRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PersonalInformationRouteArgs>();
      return _i7.PersonalInformationPage(
        mongoUser: args.mongoUser,
        key: args.key,
      );
    },
  );
}

class PersonalInformationRouteArgs {
  const PersonalInformationRouteArgs({required this.mongoUser, this.key});

  final _i13.MongoUserModel mongoUser;

  final _i12.Key? key;

  @override
  String toString() {
    return 'PersonalInformationRouteArgs{mongoUser: $mongoUser, key: $key}';
  }
}

/// generated route for
/// [_i8.PrivacyPage]
class PrivacyRoute extends _i11.PageRouteInfo<void> {
  const PrivacyRoute({List<_i11.PageRouteInfo>? children})
    : super(PrivacyRoute.name, initialChildren: children);

  static const String name = 'PrivacyRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i8.PrivacyPage();
    },
  );
}

/// generated route for
/// [_i9.ProfilePage]
class ProfileRoute extends _i11.PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    required _i13.MongoUserModel user,
    _i12.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         ProfileRoute.name,
         args: ProfileRouteArgs(user: user, key: key),
         initialChildren: children,
       );

  static const String name = 'ProfileRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileRouteArgs>();
      return _i9.ProfilePage(user: args.user, key: args.key);
    },
  );
}

class ProfileRouteArgs {
  const ProfileRouteArgs({required this.user, this.key});

  final _i13.MongoUserModel user;

  final _i12.Key? key;

  @override
  String toString() {
    return 'ProfileRouteArgs{user: $user, key: $key}';
  }
}

/// generated route for
/// [_i10.RentReqPage]
class RentReqRoute extends _i11.PageRouteInfo<RentReqRouteArgs> {
  RentReqRoute({
    required _i13.MongoUserModel user,
    _i12.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         RentReqRoute.name,
         args: RentReqRouteArgs(user: user, key: key),
         initialChildren: children,
       );

  static const String name = 'RentReqRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RentReqRouteArgs>();
      return _i10.RentReqPage(user: args.user, key: args.key);
    },
  );
}

class RentReqRouteArgs {
  const RentReqRouteArgs({required this.user, this.key});

  final _i13.MongoUserModel user;

  final _i12.Key? key;

  @override
  String toString() {
    return 'RentReqRouteArgs{user: $user, key: $key}';
  }
}
