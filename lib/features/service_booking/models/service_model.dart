// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ServiceModel {
  final String id;
  final String name;
  final String imageUrl;
  final String availability;
  final String category;
  final int price;
  final num createdAt;
  final num duration;
  final int rating;  
  ServiceModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.availability,
    required this.category,
    required this.price,
    required this.createdAt,
    required this.duration,
    required this.rating,
  });

  ServiceModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? availability,
    String? category,
    int? price,
    num? createdAt,
    num? duration,
    int? rating,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      availability: availability ?? this.availability,
      category: category ?? this.category,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      duration: duration ?? this.duration,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'availability': availability,
      'category': category,
      'price': price,
      'createdAt': createdAt,
      'duration': duration,
      'rating': rating,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      availability: map['availability'] as String,
      category: map['category'] as String,
      price: map['price'] as int,
      createdAt: map['createdAt'] as num,
      duration: map['duration'] as num,
      rating: map['rating'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceModel.fromJson(String source) => ServiceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ServiceModel(id: $id, name: $name, imageUrl: $imageUrl, availability: $availability, category: $category, price: $price, createdAt: $createdAt, duration: $duration, rating: $rating)';
  }

  @override
  bool operator ==(covariant ServiceModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.imageUrl == imageUrl &&
      other.availability == availability &&
      other.category == category &&
      other.price == price &&
      other.createdAt == createdAt &&
      other.duration == duration &&
      other.rating == rating;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      imageUrl.hashCode ^
      availability.hashCode ^
      category.hashCode ^
      price.hashCode ^
      createdAt.hashCode ^
      duration.hashCode ^
      rating.hashCode;
  }
}
