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

import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/services/jsonConverters.dart';
import 'package:core/domains/domains.dart';

part 'finDoc_model.freezed.dart';
part 'finDoc_model.g.dart';

@freezed
class FinDoc with _$FinDoc {
  FinDoc._();
  factory FinDoc({
    @FinDocTypeConverter() FinDocType? docType, // invoice, payment etc
    @Default(true) bool sales,
    String? orderId,
    String? shipmentId,
    String? invoiceId,
    String? paymentId,
    String? transactionId,
    @JsonKey(name: 'statusId')
    @FinDocStatusValConverter()
        FinDocStatusVal? status,
    @DateTimeConverter() DateTime? creationDate,
    @DateTimeConverter() DateTime? placedDate,
    String? description,
    User?
        otherUser, //a single person responsible for finDoc of a single company
    @DecimalConverter() Decimal? grandTotal,
    String? classificationId, // is productStore
    @Default([]) List<FinDocItem> items,
  }) = _FinDoc;

  factory FinDoc.fromJson(Map<String, dynamic> json) => _$FinDocFromJson(json);

  bool idIsNull() => (invoiceId == null &&
          orderId == null &&
          shipmentId == null &&
          paymentId == null &&
          transactionId == null)
      ? true
      : false;

  String salesString() => sales == true ? 'Sales' : 'Purchase';

  String? id() => idIsNull()
      ? 'New'
      : docType == FinDocType.order
          ? orderId
          : docType == FinDocType.shipment
              ? shipmentId
              : docType == FinDocType.payment
                  ? paymentId
                  : docType == FinDocType.invoice
                      ? invoiceId
                      : docType == FinDocType.transaction
                          ? transactionId
                          : null;

  List<String?> otherIds() => docType == FinDocType.order
      ? ['shipment', shipmentId, 'invoice', invoiceId, 'payment', paymentId]
      : [];

  String toString() =>
      "$docType# $orderId!/$shipmentId/$invoiceId!/$paymentId! s/p: ${salesString()} "
      "Date: $creationDate! $description! ";
//      "status: $statusId! otherUser: $otherUser! Items: ${items!.length}";

  String? displayName(String classificationId) {
    switch (classificationId) {
      case 'AppHotel':
        return finDocStatusValuesHotel[status.toString()];
      default:
        return finDocStatusValues[status.toString()];
    }
  }
}

Map<String, String> finDocStatusValues = {
  // explanation of status values
  'FinDocPrep': 'in Preparation',
  'FinDocCreated': 'Created',
  'FinDocApproved': 'Approved',
  'FinDocCompleted': 'Completed',
  'FinDocCancelled': 'Cancelled'
};

Map<String, String> finDocStatusValuesHotel = {
  'FinDocPrep': 'in Preparation',
  'FinDocCreated': 'Created',
  'FinDocApproved': 'Checked In',
  'FinDocCompleted': 'Checked Out',
  'FinDocCancelled': 'Cancelled'
};
