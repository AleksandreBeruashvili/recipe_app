import '../../domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.name,
    required super.ingredients,
    required super.instructions,
    required super.prepTimeMinutes,
    required super.cookTimeMinutes,
    required super.servings,
    required super.difficulty,
    required super.cuisine,
    required super.caloriesPerServing,
    required super.tags,
    required super.rating,
    required super.reviewCount,
    required super.image,
    required super.mealType,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      prepTimeMinutes: json['prepTimeMinutes'] ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] ?? 0,
      servings: json['servings'] ?? 1,
      difficulty: json['difficulty'] ?? 'Easy',
      cuisine: json['cuisine'] ?? '',
      caloriesPerServing: (json['caloriesPerServing'] ?? 0).toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      image: json['image'] ?? '',
      mealType: (json['mealType'] as List?)?.join(', ') ?? '',
    );
  }
}
