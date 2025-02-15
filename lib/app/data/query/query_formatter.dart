import 'package:peopler/app/data/query/filter_condition.dart';
import 'package:peopler/app/data/query/sort_condition.dart';

abstract class QueryFormatter<T> {
  T build(List<FilterCondition> filters, List<SortCondition> sorts);
}

class Yii2QueryFormatter implements QueryFormatter<Map<String, String>> {
  @override
  Map<String, String> build(List<FilterCondition> filters, List<SortCondition> sorts) {
    final Map<String, String> params = {};

    // Handle filters
    for (var filter in filters) {
      final String paramKey = _formatFilterOperator(filter.field, filter.operator);
      params[paramKey] = filter.value.toString();
    }

    // Handle sorts
    if (sorts.isNotEmpty) {
      final sortParams = sorts.map((sort) {
        return sort.direction == SortDirection.desc 
            ? '-${sort.field}'
            : sort.field;
      }).join(',');
      
      params['sort'] = sortParams;
    }

    return params;
  }

  String _formatFilterOperator(String field, FilterOperator operator) {
    switch (operator) {
      case FilterOperator.eq:
        return field;
      case FilterOperator.ne:
        return '$field[neq]';
      case FilterOperator.gt:
        return '$field[gt]';
      case FilterOperator.lt:
        return '$field[lt]';
      case FilterOperator.ge:
        return '$field[gte]';
      case FilterOperator.le:
        return '$field[lte]';
      case FilterOperator.contains:
        return '$field[like]';
      case FilterOperator.startsWith:
        return '$field[like]';
      case FilterOperator.endsWith:
        return '$field[like]';
    }
  }
}
