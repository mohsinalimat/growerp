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

import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'wsChatMessage_model.freezed.dart';
part 'wsChatMessage_model.g.dart';

WsChatMessage wsChatMessageFromJson(String str) =>
    WsChatMessage.fromJson(json.decode(str));
String wsChatMessageToJson(WsChatMessage data) =>
    '{"wsChatMessage":' + json.encode(data.toJson()) + "}";

@freezed
class WsChatMessage with _$WsChatMessage {
  WsChatMessage._();
  factory WsChatMessage({
    String? toUserId,
    @Default('') String fromUserId,
    @Default('') String content,
    String? chatRoomId,
  }) = _WsChatMessage;

  factory WsChatMessage.fromJson(Map<String, dynamic> json) =>
      _$WsChatMessageFromJson(json);
}
