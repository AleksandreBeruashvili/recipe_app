import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getRecipes({int skip = 0, int limit = 20});
  Future<Recipe> getRecipeById(int id);
}
