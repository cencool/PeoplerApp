import 'package:peopler/app/data/query/filter_condition.dart';
import 'package:peopler/app/data/query/query_formatter.dart';
import 'package:peopler/app/data/query/sort_condition.dart';

class Yii2QueryFormatter implements QueryFormatter<Map<String, String>> {
  @override
  Map<String, String> build(List<FilterCondition> filters, List<SortCondition> sorts, {int? page}) {
    final Map<String, String> params = {};

    // Handle filters
    for (var filter in filters) {
      final String paramKey = _formatFilterOperator(filter.field, filter.operator);
      params[paramKey] = filter.value.toString();
    }

    // Handle sorts
    if (sorts.isNotEmpty) {
      final sortParams = sorts.map((sort) {
        return sort.direction == SortDirection.desc ? '-${sort.field}' : sort.field;
      }).join(',');

      params['sort'] = sortParams;
    }
// Handle pagination
    if (page != null) {
      params['page'] = page.toString();
    }

    return params;
  }

  String _formatFilterOperator(String field, FilterOperator operator) {
    switch (operator) {
      case FilterOperator.eq:
        return 'filter[$field]';
      case FilterOperator.ne:
        return 'filter[$field][neq]';
      case FilterOperator.gt:
        return 'filter[$field][gt]';
      case FilterOperator.lt:
        return 'filter[$field][lt]';
      case FilterOperator.ge:
        return 'filter[$field][gte]';
      case FilterOperator.le:
        return 'filter[$field][lte]';
      case FilterOperator.contains:
        return 'filter[$field][like]';
      case FilterOperator.startsWith:
        return 'filter[$field][like]';
      case FilterOperator.endsWith:
        return 'filter[$field][like]';
    }
  }
}
