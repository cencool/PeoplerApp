/// A generic abstract class that represents a paginated list of items of type T
abstract class PaginatedList<T> {
  /// Total number of pages
  int get pageCount;
  
  /// Current page number (1-based)
  int get currentPage;
  
  /// Number of items per page
  int get pageSize;
  
  /// Total number of items across all pages
  int get totalCount;
  
  /// List of items for the current page
  List<T> get items;

  const PaginatedList();

  /// Returns true if there is a next page available
  bool get hasNextPage => currentPage < pageCount;

  /// Returns true if there is a previous page available
  bool get hasPreviousPage => currentPage > 1;

  /// Returns the total number of items in the current page
  int get currentPageSize => items.length;

  /// Returns true if the current page is empty
  bool get isEmpty => items.isEmpty;

  /// Returns true if the current page is not empty
  bool get isNotEmpty => items.isNotEmpty;
}
