import 'package:peopler/app/data/query/filter_condition.dart';
import 'package:peopler/app/data/query/sort_condition.dart';

abstract class QueryFormatter<T> {
  T build(List<FilterCondition> filters, List<SortCondition> sorts, {int? page});
}
