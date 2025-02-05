// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i3;
import 'package:mrent/pages/naviagation_page.dart' as _i1;

/// generated route for
/// [_i1.NavigationPage]
class NavigationRoute extends _i2.PageRouteInfo<NavigationRouteArgs> {
  NavigationRoute({
    String? id,
    _i3.Key? key,
    List<_i2.PageRouteInfo>? children,
  }) : super(
          NavigationRoute.name,
          args: NavigationRouteArgs(
            id: id,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'NavigationRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NavigationRouteArgs>(
          orElse: () => const NavigationRouteArgs());
      return _i1.NavigationPage(
        id: args.id,
        key: args.key,
      );
    },
  );
}

class NavigationRouteArgs {
  const NavigationRouteArgs({
    this.id,
    this.key,
  });

  final String? id;

  final _i3.Key? key;

  @override
  String toString() {
    return 'NavigationRouteArgs{id: $id, key: $key}';
  }
}
