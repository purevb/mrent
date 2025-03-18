// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i9;
import 'package:mrent/model/user_model.dart' as _i8;
import 'package:mrent/pages/message_page/message_checker.dart' as _i1;
import 'package:mrent/pages/naviagation_page.dart' as _i2;
import 'package:mrent/pages/profile_page/pages/pages/notification_page/notification_page.dart'
    as _i3;
import 'package:mrent/pages/profile_page/pages/pages/payment_page/payment_page.dart'
    as _i4;
import 'package:mrent/pages/profile_page/pages/pages/personal_information_page/personal_information_page.dart'
    as _i5;
import 'package:mrent/pages/profile_page/pages/pages/privacy_page/privacy_page.dart'
    as _i6;

/// generated route for
/// [_i1.MessageChecker]
class MessageChecker extends _i7.PageRouteInfo<MessageCheckerArgs> {
  MessageChecker({
    _i8.User? user,
    _i9.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          MessageChecker.name,
          args: MessageCheckerArgs(user: user, key: key),
          initialChildren: children,
        );

  static const String name = 'MessageChecker';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MessageCheckerArgs>(
        orElse: () => const MessageCheckerArgs(),
      );
      return _i1.MessageChecker(user: args.user, key: args.key);
    },
  );
}

class MessageCheckerArgs {
  const MessageCheckerArgs({this.user, this.key});

  final _i8.User? user;

  final _i9.Key? key;

  @override
  String toString() {
    return 'MessageCheckerArgs{user: $user, key: $key}';
  }
}

/// generated route for
/// [_i2.NavigationPage]
class NavigationRoute extends _i7.PageRouteInfo<NavigationRouteArgs> {
  NavigationRoute({String? id, _i9.Key? key, List<_i7.PageRouteInfo>? children})
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
      return _i2.NavigationPage(id: args.id, key: args.key);
    },
  );
}

class NavigationRouteArgs {
  const NavigationRouteArgs({this.id, this.key});

  final String? id;

  final _i9.Key? key;

  @override
  String toString() {
    return 'NavigationRouteArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i3.NotificationPage]
class NotificationRoute extends _i7.PageRouteInfo<void> {
  const NotificationRoute({List<_i7.PageRouteInfo>? children})
      : super(NotificationRoute.name, initialChildren: children);

  static const String name = 'NotificationRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.NotificationPage();
    },
  );
}

/// generated route for
/// [_i4.PaymentPage]
class PaymentRoute extends _i7.PageRouteInfo<void> {
  const PaymentRoute({List<_i7.PageRouteInfo>? children})
      : super(PaymentRoute.name, initialChildren: children);

  static const String name = 'PaymentRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.PaymentPage();
    },
  );
}

/// generated route for
/// [_i5.PersonalInformationPage]
class PersonalInformationRoute extends _i7.PageRouteInfo<void> {
  const PersonalInformationRoute({List<_i7.PageRouteInfo>? children})
      : super(PersonalInformationRoute.name, initialChildren: children);

  static const String name = 'PersonalInformationRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.PersonalInformationPage();
    },
  );
}

/// generated route for
/// [_i6.PrivacyPage]
class PrivacyRoute extends _i7.PageRouteInfo<void> {
  const PrivacyRoute({List<_i7.PageRouteInfo>? children})
      : super(PrivacyRoute.name, initialChildren: children);

  static const String name = 'PrivacyRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.PrivacyPage();
    },
  );
}
