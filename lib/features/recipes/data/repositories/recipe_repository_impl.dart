import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_datasource.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  RecipeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Recipe>> getRecipes({int skip = 0, int limit = 20}) {
    return remoteDataSource.getRecipes(skip: skip, limit: limit);
  }

  @override
  Future<Recipe> getRecipeById(int id) {
    return remoteDataSource.getRecipeById(id);
  }
}
