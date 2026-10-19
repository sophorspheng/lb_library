// To parse this JSON data, do
//
//     final getBookList = getBookListFromJson(jsonString);

import 'dart:convert';

List<GetBookList> getBookListFromJson(String str) => List<GetBookList>.from(
  json.decode(str).map((x) => GetBookList.fromJson(x)),
);

String getBookListToJson(List<GetBookList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetBookList {
  final String author;
  final String category;
  final String coverImageUrl;
  final String createdAt;
  final String description;
  final int id;
  final bool isActive;
  final bool isFavorite;
  final dynamic isbn;
  final String language;
  final int pageCount;
  final String pdfBase64;
  final String pdfContentType;
  final dynamic pdfFileName;
  final dynamic pdfSizeBytes;
  final dynamic publishedDate;
  final String publisher;
  final double rating;
  final dynamic subtitle;
  final String title;
  final int totalRatings;
  final String updatedAt;

  GetBookList({
    required this.author,
    required this.category,
    required this.coverImageUrl,
    required this.createdAt,
    required this.description,
    required this.id,
    required this.isActive,
    required this.isFavorite,
    required this.isbn,
    required this.language,
    required this.pageCount,
    required this.pdfBase64,
    required this.pdfContentType,
    required this.pdfFileName,
    required this.pdfSizeBytes,
    required this.publishedDate,
    required this.publisher,
    required this.rating,
    required this.subtitle,
    required this.title,
    required this.totalRatings,
    required this.updatedAt,
  });

  factory GetBookList.fromJson(Map<String, dynamic> json) => GetBookList(
    author: json["author"],
    category: json["category"],
    coverImageUrl: json["coverImageUrl"],
    createdAt: json["createdAt"],
    description: json["description"],
    id: json["id"],
    isActive: json["isActive"],
    isFavorite: json["isFavorite"],
    isbn: json["isbn"],
    language: json["language"],
    pageCount: json["pageCount"],
    pdfBase64: json["pdfBase64"],
    pdfContentType: json["pdfContentType"],
    pdfFileName: json["pdfFileName"],
    pdfSizeBytes: json["pdfSizeBytes"],
    publishedDate: json["publishedDate"],
    publisher: json["publisher"],
    rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
    subtitle: json["subtitle"],
    title: json["title"],
    totalRatings: json["totalRatings"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "author": author,
    "category": category,
    "coverImageUrl": coverImageUrl,
    "createdAt": createdAt,
    "description": description,
    "id": id,
    "isActive": isActive,
    "isFavorite": isFavorite,
    "isbn": isbn,
    "language": language,
    "pageCount": pageCount,
    "pdfBase64": pdfBase64,
    "pdfContentType": pdfContentType,
    "pdfFileName": pdfFileName,
    "pdfSizeBytes": pdfSizeBytes,
    "publishedDate": publishedDate,
    "publisher": publisher,
    "rating": rating,
    "subtitle": subtitle,
    "title": title,
    "totalRatings": totalRatings,
    "updatedAt": updatedAt,
  };
}
