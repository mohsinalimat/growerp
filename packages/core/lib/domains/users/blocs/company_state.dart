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

part of 'company_bloc.dart';

enum CompanyStatus { initial, success, failure }

class CompanyState extends Equatable {
  const CompanyState({
    this.status = CompanyStatus.initial,
    this.companies = const <Company>[],
    this.message,
    this.hasReachedMax = false,
    this.searchString = '',
    this.search = false,
  });

  final CompanyStatus status;
  final String? message;
  final List<Company> companies;
  final bool hasReachedMax;
  final String searchString;
  final bool search;

  CompanyState copyWith({
    CompanyStatus? status,
    String? message,
    List<Company>? companies,
    bool error = false,
    bool? hasReachedMax,
    String? searchString,
    bool? search,
  }) {
    return CompanyState(
      status: status ?? this.status,
      companies: companies ?? this.companies,
      message: message ?? this.message,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchString: searchString ?? this.searchString,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [companies, hasReachedMax, search];

  @override
  String toString() => '$status { #companies: ${companies.length}, '
      'hasReachedMax: $hasReachedMax message $message}';
}
