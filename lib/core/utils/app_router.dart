import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/recipes/presentation/pages/recipes_list_page.dart';
import '../../features/recipes/presentation/pages/recipe_detail_page.dart';
import '../../features/recipes/presentation/providers/recipe_detail_provider.dart';
import '../../features/recipes/domain/usecases/recipe_usecases.dart';
import '../../features/recipes/data/datasources/recipe_remote_datasource.dart';
import '../../features/recipes/data/repositories/recipe_repository_impl.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const RecipesListPage(),
    ),
    GoRoute(
      path: '/recipe/:id',
      builder: (_, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ChangeNotifierProvider(
          create: (_) => RecipeDetailProvider(
            GetRecipeByIdUseCase(
              RecipeRepositoryImpl(RecipeRemoteDataSource()),
            ),
          ),
          child: RecipeDetailPage(recipeId: id),
        );
      },
    ),
  ],
);
