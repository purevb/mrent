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
import 'package:mrent/pages/favorite_page/favorite_checker.dart' as _i1;
import 'package:mrent/pages/message_page/message_checker.dart' as _i2;
import 'package:mrent/pages/naviagation_page.dart' as _i3;
import 'package:mrent/pages/personal_information/personal_information_page.dart'
    as _i4;
import 'package:mrent/pages/profile_page/profile_checker.dart' as _i5;
import 'package:mrent/pages/rent_history_page/rent_checker.dart' as _i6;

/// generated route for
/// [_i1.FavoriteChecker]
class FavoriteChecker extends _i7.PageRouteInfo<FavoriteCheckerArgs> {
  FavoriteChecker({
    _i8.User? user,
    _i9.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          FavoriteChecker.name,
          args: FavoriteCheckerArgs(user: user, key: key),
          initialChildren: children,
        );

  static const String name = 'FavoriteChecker';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FavoriteCheckerArgs>(
        orElse: () => const FavoriteCheckerArgs(),
      );
      return _i1.FavoriteChecker(user: args.user, key: args.key);
    },
  );
}

class FavoriteCheckerArgs {
  const FavoriteCheckerArgs({this.user, this.key});

  final _i8.User? user;

  final _i9.Key? key;

  @override
  String toString() {
    return 'FavoriteCheckerArgs{user: $user, key: $key}';
  }
}

/// generated route for
/// [_i2.MessageChecker]
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
      return _i2.MessageChecker(user: args.user, key: args.key);
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
/// [_i3.NavigationPage]
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
      return _i3.NavigationPage(id: args.id, key: args.key);
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
/// [_i5.ProfileChecker]
class ProfileChecker extends _i7.PageRouteInfo<ProfileCheckerArgs> {
  ProfileChecker({
    _i8.User? user,
    _i9.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          ProfileChecker.name,
          args: ProfileCheckerArgs(user: user, key: key),
          initialChildren: children,
        );

  static const String name = 'ProfileChecker';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileCheckerArgs>(
        orElse: () => const ProfileCheckerArgs(),
      );
      return _i5.ProfileChecker(user: args.user, key: args.key);
    },
  );
}

class ProfileCheckerArgs {
  const ProfileCheckerArgs({this.user, this.key});

  final _i8.User? user;

  final _i9.Key? key;

  @override
  String toString() {
    return 'ProfileCheckerArgs{user: $user, key: $key}';
  }
}

/// generated route for
/// [_i6.RentChecker]
class RentChecker extends _i7.PageRouteInfo<RentCheckerArgs> {
  RentChecker({_i8.User? user, _i9.Key? key, List<_i7.PageRouteInfo>? children})
      : super(
          RentChecker.name,
          args: RentCheckerArgs(user: user, key: key),
          initialChildren: children,
        );

  static const String name = 'RentChecker';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RentCheckerArgs>(
        orElse: () => const RentCheckerArgs(),
      );
      return _i6.RentChecker(user: args.user, key: args.key);
    },
  );
}

class RentCheckerArgs {
  const RentCheckerArgs({this.user, this.key});

  final _i8.User? user;

  final _i9.Key? key;

  @override
  String toString() {
    return 'RentCheckerArgs{user: $user, key: $key}';
  }
}
