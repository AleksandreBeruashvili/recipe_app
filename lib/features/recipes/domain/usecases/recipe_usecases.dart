import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class GetRecipesUseCase {
  final RecipeRepository repository;
  GetRecipesUseCase(this.repository);

  Future<List<Recipe>> call({int skip = 0, int limit = 20}) {
    return repository.getRecipes(skip: skip, limit: limit);
  }
}

class GetRecipeByIdUseCase {
  final RecipeRepository repository;
  GetRecipeByIdUseCase(this.repository);

  Future<Recipe> call(int id) {
    return repository.getRecipeById(id);
  }
}
