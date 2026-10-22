class PaginatedResult<T> {
  const PaginatedResult({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.nextPageUrl,
  });

  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? nextPageUrl;

  bool get hasMore => currentPage < lastPage;

  PaginatedResult<R> map<R>(R Function(T) transform) => PaginatedResult<R>(
    data: data.map(transform).toList(growable: false),
    currentPage: currentPage,
    lastPage: lastPage,
    perPage: perPage,
    total: total,
    nextPageUrl: nextPageUrl,
  );

  factory PaginatedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final rows = json['data'];
    final meta = json['meta'];
    final links = json['links'];
    if (rows is! List || meta is! Map) {
      throw const FormatException('Invalid paginated API response.');
    }
    return PaginatedResult<T>(
      data: rows
          .whereType<Map>()
          .map((row) => fromJson(Map<String, dynamic>.from(row)))
          .toList(growable: false),
      currentPage: _integer(meta['current_page'], fallback: 1),
      lastPage: _integer(meta['last_page'], fallback: 1),
      perPage: _integer(meta['per_page'], fallback: rows.length),
      total: _integer(meta['total'], fallback: rows.length),
      nextPageUrl: links is Map ? links['next'] as String? : null,
    );
  }

  static int _integer(Object? value, {required int fallback}) =>
      value is int ? value : int.tryParse('$value') ?? fallback;
}
