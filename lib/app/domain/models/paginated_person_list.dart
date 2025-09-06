import 'package:peopler/app/domain/models/base/paginated_list.dart';
import 'package:peopler/app/domain/models/person.dart';

class PaginatedPersonList extends PaginatedList<Person> {
  PaginatedPersonList({
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    required this.pageCount,
    required this.items,
  });

  /// Total number of pages
  @override
  final int pageCount;

  /// Current page number (1-based)
  @override
  final int currentPage;

  /// Number of items per page
  @override
  final int pageSize;

  /// Total number of items across all pages
  @override
  final int totalCount;

  /// List of items for the current page
  @override
  final List<Person> items;
}
