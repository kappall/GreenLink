class PaginatedResult<T> {
  final List<T> items;
  final int page;
  final bool hasMore;

  const PaginatedResult({
    this.items = const [],
    this.page = 1,
    this.hasMore = true,
  });

  PaginatedResult<T> copyWith({List<T>? items, int? page, bool? hasMore}) {
    return PaginatedResult<T>(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
