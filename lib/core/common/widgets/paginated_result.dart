class PaginatedResult<T> {
  final List<T> items;
  final int page;
  final bool hasMore;
  final int totalItems;

  const PaginatedResult({
    this.items = const [],
    this.page = 1,
    this.hasMore = true,
    this.totalItems = 0,
  });

  PaginatedResult<T> copyWith({
    List<T>? items,
    int? page,
    bool? hasMore,
    int? totalItems,
  }) {
    return PaginatedResult<T>(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}
