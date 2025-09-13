import 'dart:convert';
import 'dart:developer' as console;

import '../domain/models/index.dart';

class ApiPaginateResponse<T> {
  final int? currentPage;
  final List<T>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  ApiPaginateResponse({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  ApiPaginateResponse copyWith({
    int? currentPage,
    List<T>? data,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    String? nextPageUrl,
    int? perPage,
    String? prevPageUrl,
    int? to,
    int? total,
  }) => ApiPaginateResponse(
    currentPage: currentPage ?? this.currentPage,
    data: data ?? this.data,
    firstPageUrl: firstPageUrl ?? this.firstPageUrl,
    from: from ?? this.from,
    lastPage: lastPage ?? this.lastPage,
    lastPageUrl: lastPageUrl ?? this.lastPageUrl,
    nextPageUrl: nextPageUrl ?? this.nextPageUrl,
    perPage: perPage ?? this.perPage,
    prevPageUrl: prevPageUrl ?? this.prevPageUrl,
    to: to ?? this.to,
    total: total ?? this.total,
  );

  factory ApiPaginateResponse.fromJson(String str) =>
      ApiPaginateResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ApiPaginateResponse.fromMap(Map<String, dynamic> json) =>
      ApiPaginateResponse(
        currentPage: json["current_page"],
        data:
            json["data"] == null
                ? []
                : List<T>.from(
                  json["data"]!.map((x) => castToObjectModel(x, T)),
                ),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toMap() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<T>.from(data!.map((x) => x)),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "next_page_url": nextPageUrl,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };

  static castToObjectModel(dynamic x, Type t) {
    console.log(t.toString(), name: "castToObjectModel");
    switch (t.toString()) {
      case "EstateModel":
        return EstateModel.fromMap(x);
    }
    return x;
  }
}
