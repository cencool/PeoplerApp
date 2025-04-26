// lib/app/data/query/query_utils.dart

// Import necessary types
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart'; // For accessing static names like PlutoFilterTypeContains.name
import 'package:peopler/app/data/query/filter_condition.dart';

/// Maps a PlutoGrid filter title string to the application's FilterOperator enum.
///
/// Takes a [plutoFilterTitle] string (obtained from PlutoFilterType.title,
/// often corresponding to PlutoFilterType*.name) and returns the corresponding
/// [FilterOperator].
/// Returns `null` if the title doesn't match any known filter type.
FilterOperator? mapPlutoFilterTitleToOperator(String plutoFilterTitle) {
  // Use if-else if chain as PlutoFilterType.name is not const
  if (plutoFilterTitle == PlutoFilterTypeContains.name) {
    return FilterOperator.contains;
  } else if (plutoFilterTitle == PlutoFilterTypeEquals.name) {
    return FilterOperator.eq;
  } else if (plutoFilterTitle == PlutoFilterTypeStartsWith.name) {
    return FilterOperator.startsWith;
  } else if (plutoFilterTitle == PlutoFilterTypeEndsWith.name) {
    return FilterOperator.endsWith;
  } else if (plutoFilterTitle == PlutoFilterTypeGreaterThan.name) {
    return FilterOperator.gt;
  } else if (plutoFilterTitle == PlutoFilterTypeGreaterThanOrEqualTo.name) {
    return FilterOperator.ge;
  } else if (plutoFilterTitle == PlutoFilterTypeLessThan.name) {
    return FilterOperator.lt;
  } else if (plutoFilterTitle == PlutoFilterTypeLessThanOrEqualTo.name) {
    return FilterOperator.le;
  } else {
    // Handle unmapped titles: return null, throw an error, or map to a default.
    // PlutoGrid's default filters don't include a 'Not Equals', so no mapping for FilterOperator.ne here.
    debugPrint("Warning: Unmapped Pluto filter title encountered: $plutoFilterTitle");
    return null;
  }
}
