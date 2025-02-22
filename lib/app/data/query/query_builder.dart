import 'package:peopler/app/data/query/filter_condition.dart';
import 'package:peopler/app/data/query/query_formatter.dart';
import 'package:peopler/app/data/query/sort_condition.dart';

/// A builder class for constructing database queries with filtering and sorting capabilities.
///
/// This class follows the Builder pattern to create complex queries in a fluent, chainable way.
/// Example usage:
/// ```dart
/// final query = QueryBuilder()
///   .filter('age', FilterOperator.gt, 18)
///   .sort('name', SortDirection.asc)
///   .build(formatter);
/// ```
class QueryBuilder {
  final List<FilterCondition> _filters = [];
  final List<SortCondition> _sorts = [];

  /// Adds a filter condition to the query.
  ///
  /// [field] The field name to filter on
  /// [operator] The comparison operator to use
  /// [value] The value to compare against
  /// Returns this builder instance for method chaining
  QueryBuilder filter(String field, FilterOperator operator, dynamic value) {
    _filters.add(FilterCondition(field: field, operator: operator, value: value));
    return this;
  }

  /// Adds a sort condition to the query.
  ///
  /// [field] The field name to sort by
  /// [direction] The sort direction (ascending or descending)
  /// Returns this builder instance for method chaining
  QueryBuilder sort(String field, SortDirection direction) {
    _sorts.add(SortCondition(field: field, direction: direction));
    return this;
  }

  /// Builds the final query using the provided formatter.
  ///
  /// [formatter] A formatter that converts the query conditions into the target format
  /// Returns the formatted query of type [T]
  T build<T>(QueryFormatter<T> formatter) {
    return formatter.build(_filters, _sorts);
  }
}
