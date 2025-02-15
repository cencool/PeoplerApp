enum FilterOperator { eq, ne, gt, lt, ge, le, contains, startsWith, endsWith }

class FilterCondition {
  final String field;
  final FilterOperator operator;
  final dynamic value;

  FilterCondition({required this.field, required this.operator, required this.value});
}
