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

part of 'location_bloc.dart';

enum LocationStatus { initial, success, failure }

class LocationState extends Equatable {
  const LocationState({
    this.status = LocationStatus.initial,
    this.locations = const <Location>[],
    this.message,
    this.hasReachedMax = false,
    this.searchString = '',
    this.search = false,
  });

  final LocationStatus status;
  final String? message;
  final List<Location> locations;
  final bool hasReachedMax;
  final String searchString;
  final bool search;

  LocationState copyWith({
    LocationStatus? status,
    String? message,
    List<Location>? locations,
    bool error = false,
    bool? hasReachedMax,
    String? searchString,
    bool? search,
  }) {
    return LocationState(
      status: status ?? this.status,
      locations: locations ?? this.locations,
      message: message ?? this.message,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchString: searchString ?? this.searchString,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [locations, hasReachedMax, search];

  @override
  String toString() => '$status { #locations: ${locations.length}, '
      'hasReachedMax: $hasReachedMax message $message}';
}
