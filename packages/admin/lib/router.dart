/*
 * This GrowERP software is in the public domain under CC0 1.0 Universal plus a
 * Grant of Patent License.
 * 
 * To the extent possible under law, the author(s) have dedicated all
 * copyright and related and neighboring rights to this software to the
 * public domain worldwide. This software is distributed without any
 * warranty.
 * 
 * You should have received a copy of the CC0 Public Domain Dedication
 * along with this software (see the LICENSE.md file). If not, see
 * <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

import 'package:core/coreRouter.dart';
import 'package:core/domains/domains.dart';
import 'package:core/templates/@templates.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'menuItem_data.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  if (kDebugMode) {
    print('>>>NavigateTo { ${settings.name} '
        'with: ${settings.arguments.toString()} }');
  }
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
          builder: (context) => HomeForm(menuItems: menuItems));
    case '/company':
      return MaterialPageRoute(
          builder: (context) =>
              DisplayMenuItem(menuList: menuItems, menuIndex: 1, tabIndex: 0));
    case '/crm':
      return MaterialPageRoute(
          builder: (context) =>
              DisplayMenuItem(menuList: menuItems, menuIndex: 2, tabIndex: 0));
    case '/catalog':
      return MaterialPageRoute(
          builder: (context) =>
              DisplayMenuItem(menuList: menuItems, menuIndex: 3, tabIndex: 0));
    case '/orders':
      return MaterialPageRoute(
          builder: (context) =>
              DisplayMenuItem(menuList: menuItems, menuIndex: 4, tabIndex: 0));
    case '/warehouse':
      return MaterialPageRoute(
          builder: (context) =>
              DisplayMenuItem(menuList: menuItems, menuIndex: 5, tabIndex: 0));
    default:
      return coreRoute(settings);
  }
}
