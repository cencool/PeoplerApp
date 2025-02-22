/// Represents the available comparison operators for filtering data.
/// 
/// Supported operators:
/// * [eq] - Equal to
/// * [ne] - Not equal to
/// * [gt] - Greater than
/// * [lt] - Less than
/// * [ge] - Greater than or equal to
/// * [le] - Less than or equal to
/// * [contains] - Contains the substring
/// * [startsWith] - Starts with the substring
/// * [endsWith] - Ends with the substring
enum FilterOperator { eq, ne, gt, lt, ge, le, contains, startsWith, endsWith }

/// A condition used for filtering data based on field, operator, and value.
///
/// This class is used to build query filters where:
/// * [field] specifies the property name to filter on
/// * [operator] defines the comparison operation to perform
/// * [value] is the value to compare against
class FilterCondition {
  final String field;
  final FilterOperator operator;
  final dynamic value;

  FilterCondition({required this.field, required this.operator, required this.value});
}
