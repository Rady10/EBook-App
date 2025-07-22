import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Book {
  final String name;
  final String description;
  final String author;
  final String image;
  final double price;
  final String? id;
  final String? userId;
  Book({
    required this.name,
    required this.description,
    required this.author,
    required this.image,
    required this.price,
    this.id,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'author': author,
      'image': image,
      'price': price,
      'id': id,
      'userId': userId,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      author: map['author'] ?? '',
      image: map['image'] ?? '',
      price: map['price'] is int ? (map['price'] as int).toDouble() : (map['price'] as double? ?? 0.0),
      id: map['_id'] ?? '',
      userId: map['user'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source) as Map<String, dynamic>);
}
