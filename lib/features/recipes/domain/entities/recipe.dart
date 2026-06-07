import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final int id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String difficulty;
  final String cuisine;
  final double caloriesPerServing;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final String image;
  final String mealType;

  const Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.cuisine,
    required this.caloriesPerServing,
    required this.tags,
    required this.rating,
    required this.reviewCount,
    required this.image,
    required this.mealType,
  });

  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  @override
  List<Object?> get props => [id];
}
