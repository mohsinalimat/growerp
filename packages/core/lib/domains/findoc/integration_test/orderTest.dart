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
import 'package:core/domains/domains.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import '../../common/integration_test/commonTest.dart';
import '../models/models.dart';
import 'package:intl/intl.dart';

class OrderTest {
  static Future<void> selectPurchaseOrders(WidgetTester tester) async {
    await CommonTest.selectOption(
        tester, 'dbOrders', 'FinDocListFormPurchaseOrder', '3');
  }

  static Future<void> selectSalesOrders(WidgetTester tester) async {
    await CommonTest.selectOption(
        tester, 'dbOrders', 'FinDocListFormSalesOrder', '1');
  }

  static Future<void> createPurchaseOrder(
      WidgetTester tester, List<FinDoc> finDocs) async {
    List<FinDoc> orders = [];
    for (FinDoc order in finDocs) {
      // enter purchase order dialog
      await CommonTest.tapByKey(tester, 'addNew');
      await CommonTest.checkWidgetKey(tester, 'FinDocDialogPurchaseOrder');
      await CommonTest.tapByKey(tester, 'clear', seconds: 2);
      await CommonTest.enterText(tester, 'description', order.description!);
      // enter supplier
      await CommonTest.enterDropDownSearch(
          tester, 'supplier', order.otherUser!.companyName!);
      // add product data
      await CommonTest.tapByKey(tester, 'addProduct', seconds: 1);
      await CommonTest.checkWidgetKey(tester, 'addProductItemDialog');
      await CommonTest.enterDropDownSearch(
          tester, 'product', order.items[0].description!);
      await CommonTest.drag(tester, listViewName: 'listView3');
      await CommonTest.enterText(
          tester, 'price', order.items[0].price.toString());
      await CommonTest.enterText(
          tester, 'quantity', order.items[0].quantity.toString());
      await CommonTest.tapByKey(tester, 'ok');
      // create order
      await CommonTest.tapByKey(tester, 'update', seconds: 5);
      // get productId
      await CommonTest.tapByKey(tester, 'id0');
      FinDocItem newItem = order.items[0].copyWith(
          productId: CommonTest.getTextField('itemLine0').split(' ')[1]);
      await CommonTest.tapByKey(tester, 'id0');
      // save order with orderId and productId
      orders.add(order
          .copyWith(orderId: CommonTest.getTextField('id0'), items: [newItem]));
    }
    // save when successfull
    SaveTest test = await PersistFunctions.getTest();
    await PersistFunctions.persistTest(test.copyWith(orders: finDocs));
  }

  static Future<void> createSalesOrder(
      WidgetTester tester, List<FinDoc> finDocs) async {
    List<FinDoc> orders = [];
    for (FinDoc order in finDocs) {
      // enter purchase order dialog
      await CommonTest.tapByKey(tester, 'addNew');
      await CommonTest.checkWidgetKey(tester, 'FinDocDialogSalesOrder');
      await CommonTest.tapByKey(tester, 'clear', seconds: 2);
      await CommonTest.enterText(tester, 'description', order.description!);
      // enter supplier
      await CommonTest.enterDropDownSearch(
          tester, 'customer', order.otherUser!.companyName!);
      // add product data
      for (FinDocItem item in order.items) {
        await CommonTest.tapByKey(tester, 'addProduct', seconds: 1);
        await CommonTest.checkWidgetKey(tester, 'addProductItemDialog');
        await CommonTest.enterDropDownSearch(
            tester, 'product', item.description!);
        await CommonTest.drag(tester, listViewName: 'listView3');
        await CommonTest.enterText(tester, 'price', item.price.toString());
        await CommonTest.enterText(
            tester, 'quantity', item.quantity.toString());
        await CommonTest.tapByKey(tester, 'ok');
      }
      // create order
      await CommonTest.drag(tester, listViewName: 'listView1');
      await CommonTest.tapByKey(tester, 'update', seconds: 5);
      // get productId
      await CommonTest.tapByKey(tester, 'id0');
      List<FinDocItem> newItems = List.of(order.items);
      for (int index = 0; index < order.items.length; index++) {
        var productId = CommonTest.getTextField('itemLine$index').split(' ')[1];
        FinDocItem newItem = order.items[index].copyWith(productId: productId);
        newItems[index] = newItem;
      }
      await CommonTest.tapByKey(tester, 'id0');
      // save order with orderId and productId
      orders.add(order.copyWith(
          orderId: CommonTest.getTextField('id0'), items: newItems));
    }
    // save when successfull
    SaveTest test = await PersistFunctions.getTest();
    await PersistFunctions.persistTest(test.copyWith(orders: orders));
  }

  static Future<void> createRentalSalesOrder(
      WidgetTester tester, List<FinDoc> finDocs) async {
    SaveTest test = await PersistFunctions.getTest();
    var usFormat = new DateFormat('M/d/yyyy');
    for (FinDoc finDoc in finDocs) {
      await CommonTest.tapByKey(tester, 'addNew');
      await CommonTest.tapByKey(tester, 'customer');
      await CommonTest.tapByText(tester, finDoc.otherUser!.companyName!);
      await CommonTest.tapByKey(tester, 'itemRental');
      await CommonTest.tapByKey(tester, 'product');
      await CommonTest.tapByText(tester, finDoc.items[0].description!);
      await CommonTest.tapByKey(tester, 'setDate');
      await CommonTest.tapByTooltip(tester, 'Switch to input');
      await tester.enterText(find.byType(TextField).last,
          usFormat.format(finDoc.items[0].rentalFromDate!));
      await tester.pump();
      await CommonTest.tapByText(tester, 'OK');
      DateTime textField = DateTime.parse(CommonTest.getTextField('date'));
      expect(usFormat.format(textField),
          usFormat.format(finDoc.items[0].rentalFromDate!));
      await CommonTest.enterText(
          tester, 'quantity', finDoc.items[0].quantity.toString());
      await CommonTest.tapByKey(tester, 'okRental');
      await CommonTest.tapByKey(tester, 'update', seconds: 10);
      // get productId
      await CommonTest.tapByKey(tester, 'id0');
      List<FinDocItem> newItems = List.of(finDoc.items);
      for (int index = 0; index < finDoc.items.length; index++) {
        var productId = CommonTest.getTextField('itemLine$index').split(' ')[1];
        FinDocItem newItem = finDoc.items[index].copyWith(productId: productId);
        newItems[index] = newItem;
      }
      await CommonTest.tapByKey(tester, 'id0');
      test.orders.add(finDoc.copyWith(
          orderId: CommonTest.getTextField('id0'), items: newItems));
    }
    await PersistFunctions.persistTest(test);
  }

  static Future<void> checkPurchaseOrder(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      // check list
      expect(CommonTest.getTextField('id0'), equals(order.orderId!));
      await CommonTest.tapByKey(tester, 'id0'); // open detail
      expect(order.items[0].productId,
          CommonTest.getTextField('itemLine0').split(' ')[1]);
      await CommonTest.checkText(tester, order.items[0].description!);
      await CommonTest.tapByKey(tester, 'id0'); // close detail
      // check detail
      await CommonTest.tapByKey(tester, 'edit0');
      await CommonTest.checkText(tester, order.orderId!);
      await CommonTest.checkText(tester, order.items[0].description!);
      await CommonTest.tapByKey(tester, 'cancel'); // cancel dialog
      await CommonTest.closeSearch(tester);
    }
  }

  static Future<void> checkSalesOrder(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      // check list
      expect(CommonTest.getTextField('id0'), equals(order.orderId!));
      await CommonTest.tapByKey(tester, 'id0'); // open detail
      for (int index = 0; index < order.items.length; index++) {
        expect(order.items[index].productId,
            CommonTest.getTextField('itemLine$index').split(' ')[1]);
        await CommonTest.checkText(tester, order.items[index].description!);
      }
      await CommonTest.tapByKey(tester, 'id0'); // close detail
      // check detail
      await CommonTest.tapByKey(tester, 'edit0');
      await CommonTest.checkText(tester, order.orderId!);
      await CommonTest.checkText(tester, order.items[0].description!);
      await CommonTest.tapByKey(tester, 'cancel'); // cancel dialog
      await CommonTest.closeSearch(tester);
    }
  }

  static Future<void> checkRentalSalesOrder(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    var intlFormat = new DateFormat('yyyy-MM-dd');
    int x = 0;
    for (FinDoc order in test.orders) {
      expect(CommonTest.getTextField('status$x'), equals('in Preparation'));
      await CommonTest.tapByKey(tester, 'id$x', seconds: 5);
      expect(CommonTest.getTextField('itemLine$x'),
          contains(intlFormat.format(order.items[0].rentalFromDate!)));
      x++;
    }
  }

  static Future<void> checkRentalSalesOrderBlocDates(
      WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    var usFormat = new DateFormat('M/d/yyyy');
    await CommonTest.tapByKey(tester, 'addNew');
    await CommonTest.tapByKey(tester, 'itemRental');
    await CommonTest.tapByKey(tester, 'product');
    await CommonTest.tapByText(tester, test.orders[0].items[0].description!);
    await CommonTest.tapByKey(tester, 'setDate');
    await CommonTest.tapByTooltip(tester, 'Switch to input');
    await tester.enterText(find.byType(TextField).last,
        usFormat.format(test.orders[0].items[0].rentalFromDate!));
    await tester.pump();
    await CommonTest.tapByText(tester, 'OK');
    expect(find.text('Out of range.'), findsOneWidget);
    await CommonTest.tapByText(tester, 'CANCEL');
    await CommonTest.tapByKey(tester, 'cancel');
    await CommonTest.tapByKey(tester, 'cancel');
  }

  static Future<void> sendPurchaseOrder(
      WidgetTester tester, List<FinDoc> orders) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      await CommonTest.tapByKey(tester, 'nextStatus0',
          seconds: 5); // to created
      await CommonTest.tapByKey(tester, 'nextStatus0',
          seconds: 5); // to approved
    }
    await CommonTest.gotoMainMenu(tester);
  }

  static Future<void> approveSalesOrder(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      await CommonTest.tapByKey(tester, 'nextStatus0',
          seconds: 5); // to created
      await CommonTest.tapByKey(tester, 'nextStatus0',
          seconds: 5); // to approved
    }
    await CommonTest.gotoMainMenu(tester);
  }

  static Future<void> checkOrderCompleted(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      expect(CommonTest.getTextField('status0'), equals('Completed'));
    }
  }

  /// check if the purchase order has been completed successfuly
  static Future<void> checkPurchaseOrdersComplete(WidgetTester tester) async {
    SaveTest test = await PersistFunctions.getTest();
    List<FinDoc> orders = test.orders;
    expect(orders.isNotEmpty, true,
        reason: 'This test needs orders created in previous steps');
    for (FinDoc order in orders) {
      await CommonTest.doSearch(tester, searchString: order.orderId!);
      expect(CommonTest.getTextField('status0'), 'Completed');
    }
  }
}
