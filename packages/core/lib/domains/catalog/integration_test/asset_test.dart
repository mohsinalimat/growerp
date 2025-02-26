/*
 * This software is in the public domain under CC0 1.0 Universal plus a
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

import 'package:core/domains/common/functions/persist_functions.dart';
import 'package:core/domains/integration_test.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/domains/domains.dart';
import 'package:collection/collection.dart';

class AssetTest {
  static Future<void> selectAsset(WidgetTester tester) async {
    if (find
        .byKey(Key('HomeFormAuth'))
        .toString()
        .startsWith('zero widgets with key')) {
      await CommonTest.gotoMainMenu(tester);
    }
    await CommonTest.selectOption(tester, 'dbCatalog', 'AssetListForm', '2');
  }

  static Future<void> addAssets(WidgetTester tester, List<Asset> assets,
      {bool check = true}) async {
    SaveTest test = await PersistFunctions.getTest();
    int seq = test.sequence!;
    if (test.assets.isEmpty) {
      // not yet created
      test = test.copyWith(assets: assets);
      expect(find.byKey(Key('userItem')), findsNWidgets(0)); // initial admin
      await enterAssetData(tester, assets);
      await PersistFunctions.persistTest(
          test.copyWith(assets: assets, sequence: seq));
    }
    if (check && test.assets[0].assetId.isEmpty) {
      await checkAssetList(tester, assets);
      await PersistFunctions.persistTest(test.copyWith(
        assets: await checkAssetDetail(tester, test.assets),
        sequence: seq,
      ));
    }
  }

  static Future<void> enterAssetData(
      WidgetTester tester, List<Asset> assets) async {
    int index = 0;
    for (Asset asset in assets) {
      if (asset.assetId.isEmpty)
        await CommonTest.tapByKey(tester, 'addNew');
      else {
        await CommonTest.tapByKey(tester, 'name$index');
        expect(CommonTest.getTextField('header').split('#')[1], asset.assetId);
      }
      await CommonTest.checkWidgetKey(tester, 'AssetDialog');
      await CommonTest.tapByKey(
          tester, 'name'); // required because keyboard come up
      await CommonTest.enterText(tester, 'name', asset.assetName!);
      await CommonTest.enterText(
          tester, 'quantityOnHand', asset.quantityOnHand.toString());
      await CommonTest.enterDropDownSearch(
          tester, 'productDropDown', asset.product!.productName!);
      await CommonTest.enterDropDown(tester, 'statusDropDown', asset.statusId!);
      await CommonTest.drag(tester);
      await CommonTest.tapByKey(tester, 'update', seconds: 5);
      await tester.pumpAndSettle(); // for the message to disappear
      index++;
    }
  }

  static Future<void> checkAssetList(
      WidgetTester tester, List<Asset> assets) async {
    await CommonTest.refresh(tester);
    assets.forEachIndexed((index, asset) {
      expect(CommonTest.getTextField('name$index'), equals(asset.assetName));
      if (!CommonTest.isPhone()) {
        expect(
            CommonTest.getTextField('statusId$index'), equals(asset.statusId));
      }
      expect(CommonTest.getTextField('product$index'),
          equals(asset.product!.productName!));
    });
  }

  static Future<List<Asset>> checkAssetDetail(
      WidgetTester tester, List<Asset> assets) async {
    int index = 0;
    List<Asset> newAssets = [];
    for (Asset asset in assets) {
      await CommonTest.tapByKey(tester, 'name${index}');
      var id = CommonTest.getTextField('header').split('#')[1];
      expect(find.byKey(Key('AssetDialog')), findsOneWidget);
      expect(CommonTest.getTextFormField('name'), equals(asset.assetName!));
      expect(CommonTest.getTextFormField('quantityOnHand'),
          equals(asset.quantityOnHand.toString()));
      expect(CommonTest.getDropdownSearch('productDropDown'),
          asset.product!.productName!);
      expect(CommonTest.getDropdown('statusDropDown'), asset.statusId);
      newAssets.add(asset.copyWith(assetId: id));
      index++;
      await CommonTest.tapByKey(tester, 'cancel');
    }
    return newAssets;
  }

  static Future<void> deleteAssets(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    int count = test.assets.length;
    if (count != assets.length) return;
    expect(find.byKey(Key('assetItem')), findsNWidgets(count)); // initial admin
    await CommonTest.tapByKey(tester, 'delete${count - 1}', seconds: 5);
    expect(find.byKey(Key('assetItem')), findsNWidgets(count - 1));
    test.assets.removeAt(count - 1);
    PersistFunctions.persistTest(test);
  }

  static Future<void> updateAssets(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    // check if already modified then skip
    if (test.assets[0].assetName != assets[0].assetName) return;
    List<Asset> updAssets = [];
    for (Asset asset in test.assets) {
      updAssets.add(asset.copyWith(
        assetName: asset.assetName! + 'u',
        quantityOnHand: Decimal.parse(asset.quantityOnHand.toString()) +
            Decimal.parse('10'),
      ));
    }
    test = test.copyWith(assets: updAssets);
    await enterAssetData(tester, test.assets);
    await checkAssetDetail(tester, test.assets);
    await PersistFunctions.persistTest(test);
  }
}
