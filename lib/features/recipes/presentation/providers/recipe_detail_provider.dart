import 'package:flutter/material.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/usecases/recipe_usecases.dart';

enum DetailStatus { initial, loading, loaded, error }

class RecipeDetailProvider extends ChangeNotifier {
  final GetRecipeByIdUseCase getRecipeByIdUseCase;

  RecipeDetailProvider(this.getRecipeByIdUseCase);

  Recipe? _recipe;
  DetailStatus _status = DetailStatus.initial;
  String _error = '';

  Recipe? get recipe => _recipe;
  DetailStatus get status => _status;
  String get error => _error;

  Future<void> loadRecipe(int id) async {
    _status = DetailStatus.loading;
    _recipe = null;
    notifyListeners();

    try {
      _recipe = await getRecipeByIdUseCase(id);
      _status = DetailStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = DetailStatus.error;
    }
    notifyListeners();
  }
}
