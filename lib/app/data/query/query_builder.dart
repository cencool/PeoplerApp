import 'package:peopler/app/data/query/filter_condition.dart';
import 'package:peopler/app/data/query/query_formatter.dart';
import 'package:peopler/app/data/query/sort_condition.dart';

class QueryBuilder {
  final List<FilterCondition> _filters = [];
  final List<SortCondition> _sorts = [];

  QueryBuilder filter(String field, FilterOperator operator, dynamic value) {
    _filters.add(FilterCondition(field: field, operator: operator, value: value));
    return this;
  }

  QueryBuilder sort(String field, SortDirection direction) {
    _sorts.add(SortCondition(field: field, direction: direction));
    return this;
  }

  T build<T>(QueryFormatter<T> formatter) {
    return formatter.build(_filters, _sorts);
  }
}
