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

import 'package:core/domains/warehouse/models/location_model.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/services/jsonConverters.dart';
import 'package:flutter/foundation.dart';

part 'finDocItem_model.freezed.dart';
part 'finDocItem_model.g.dart';

@freezed
class FinDocItem with _$FinDocItem {
  FinDocItem._();
  factory FinDocItem({
    String? itemSeqId,
    String? itemTypeId,
    String? itemTypeName,
    String? productId,
    String? description,
    @DecimalConverter() Decimal? quantity,
    @DecimalConverter() Decimal? price,
    String? glAccountId,
    String? assetId,
    String? assetName,
    Location? location,
    @DateTimeConverter() DateTime? rentalFromDate,
    @DateTimeConverter() DateTime? rentalThruDate,
  }) = _FinDocItem;

  factory FinDocItem.fromJson(Map<String, dynamic> json) =>
      _$FinDocItemFromJson(json);
}
