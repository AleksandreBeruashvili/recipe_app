import 'package:flutter/material.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/usecases/recipe_usecases.dart';

enum RecipesStatus { initial, loading, loaded, error }

class RecipesProvider extends ChangeNotifier {
  final GetRecipesUseCase getRecipesUseCase;

  RecipesProvider(this.getRecipesUseCase);

  List<Recipe> _recipes = [];
  RecipesStatus _status = RecipesStatus.initial;
  String _error = '';
  int _skip = 0;
  bool _hasMore = true;
  bool _loadingMore = false;

  List<Recipe> get recipes => _recipes;
  RecipesStatus get status => _status;
  String get error => _error;
  bool get hasMore => _hasMore;
  bool get loadingMore => _loadingMore;

  Future<void> loadRecipes({bool refresh = false}) async {
    if (refresh) {
      _skip = 0;
      _hasMore = true;
      _recipes = [];
    }

    if (_status == RecipesStatus.loading || _loadingMore) return;

    if (_recipes.isEmpty) {
      _status = RecipesStatus.loading;
    } else {
      _loadingMore = true;
    }
    notifyListeners();

    try {
      final result = await getRecipesUseCase(skip: _skip, limit: 20);
      if (result.length < 20) _hasMore = false;
      _recipes.addAll(result);
      _skip += result.length;
      _status = RecipesStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = RecipesStatus.error;
    } finally {
      _loadingMore = false;
      notifyListeners();
    }
  }
}
