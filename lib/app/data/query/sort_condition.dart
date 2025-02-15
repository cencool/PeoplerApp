enum SortDirection { asc, desc }

class SortCondition {
  final String field;
  final SortDirection direction;

  SortCondition({required this.field, required this.direction});
}
