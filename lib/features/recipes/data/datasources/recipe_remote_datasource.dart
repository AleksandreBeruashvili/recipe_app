import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/dio_client.dart';
import '../models/recipe_model.dart';

class RecipeRemoteDataSource {
  final Dio _dio = DioClient().dio;

  Future<List<RecipeModel>> getRecipes({int skip = 0, int limit = 20}) async {
    final response = await _dio.get(
      AppConstants.recipesEndpoint,
      queryParameters: {'skip': skip, 'limit': limit},
    );
    final List recipes = response.data['recipes'] ?? [];
    return recipes.map((r) => RecipeModel.fromJson(r)).toList();
  }

  Future<RecipeModel> getRecipeById(int id) async {
    final response = await _dio.get('${AppConstants.recipesEndpoint}/$id');
    return RecipeModel.fromJson(response.data);
  }
}
