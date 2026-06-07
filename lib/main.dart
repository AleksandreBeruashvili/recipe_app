import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'features/recipes/data/datasources/recipe_remote_datasource.dart';
import 'features/recipes/data/repositories/recipe_repository_impl.dart';
import 'features/recipes/domain/usecases/recipe_usecases.dart';
import 'features/recipes/presentation/providers/recipes_provider.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RecipesProvider(
            GetRecipesUseCase(
              RecipeRepositoryImpl(RecipeRemoteDataSource()),
            ),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Recipe App',
        theme: AppTheme.theme,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
