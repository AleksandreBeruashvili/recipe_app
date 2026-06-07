import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_detail_provider.dart';
import '../../domain/entities/recipe.dart';
import '../../../../core/theme/app_theme.dart';

class RecipeDetailPage extends StatefulWidget {
  final int recipeId;

  const RecipeDetailPage({super.key, required this.recipeId});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _contentController;
  late AnimationController _fabController;
  late AnimationController _ingredientController;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;
  late Animation<double> _fabScale;

  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _ingredientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _contentFade = CurvedAnimation(parent: _contentController, curve: Curves.easeIn);
    _contentSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _contentController, curve: Curves.easeOut));
    _fabScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<RecipeDetailProvider>().loadRecipe(widget.recipeId);
      if (mounted) {
        _contentController.forward();
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) _fabController.forward();
        });
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) _ingredientController.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _fabController.dispose();
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<RecipeDetailProvider>(
        builder: (_, provider, __) {
          if (provider.status == DetailStatus.loading) {
            return _buildLoading();
          }
          if (provider.status == DetailStatus.error) {
            return _buildError(provider.error);
          }
          if (provider.recipe == null) {
            return const SizedBox();
          }
          return _buildContent(provider.recipe!);
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
            'https://assets2.lottiefiles.com/packages/lf20_szviypry.json',
            width: 160,
            height: 160,
            errorBuilder: (_, __, ___) => const CircularProgressIndicator(
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Loading recipe...',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(error),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Recipe recipe) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            _buildSliverAppBar(recipe),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _contentFade,
                child: SlideTransition(
                  position: _contentSlide,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleSection(recipe),
                      _buildStatsRow(recipe),
                      _buildTags(recipe),
                      const SizedBox(height: 8),
                      _buildIngredients(recipe),
                      _buildInstructions(recipe),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 24,
          right: 20,
          child: ScaleTransition(
            scale: _fabScale,
            child: FloatingActionButton(
              backgroundColor: AppTheme.primary,
              onPressed: () {
                setState(() => _isFavorite = !_isFavorite);
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(_isFavorite),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(Recipe recipe) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'recipe_${recipe.id}',
          child: CachedNetworkImage(
            imageUrl: recipe.image,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
                Container(color: Colors.grey[200]),
            errorWidget: (_, __, ___) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.restaurant, size: 80, color: Colors.grey),
            ),
          ),
        ),
        stretchModes: const [StretchMode.zoomBackground],
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: Colors.black26,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(Recipe recipe) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppTheme.primary),
              const SizedBox(width: 4),
              Text(
                recipe.cuisine,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              RatingBarIndicator(
                rating: recipe.rating,
                itemBuilder: (_, __) =>
                    const Icon(Icons.star, color: AppTheme.accent),
                itemCount: 5,
                itemSize: 18,
              ),
              const SizedBox(width: 6),
              Text(
                '${recipe.rating} (${recipe.reviewCount})',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(Recipe recipe) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(Icons.timer, '${recipe.prepTimeMinutes}m', 'Prep'),
          _divider(),
          _statItem(Icons.local_fire_department, '${recipe.cookTimeMinutes}m', 'Cook'),
          _divider(),
          _statItem(Icons.restaurant, '${recipe.servings}', 'Servings'),
          _divider(),
          _statItem(Icons.bolt, '${recipe.caloriesPerServing.toInt()}', 'Cal'),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primary, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(height: 40, width: 1, color: Colors.grey[300]);
  }

  Widget _buildTags(Recipe recipe) {
    if (recipe.tags.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: recipe.tags.map((tag) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '#$tag',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIngredients(Recipe recipe) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingredients',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(recipe.ingredients.length, (i) {
            return AnimatedBuilder(
              animation: _ingredientController,
              builder: (_, child) {
                final delay = (i * 0.1).clamp(0.0, 1.0);
                final progress = ((_ingredientController.value - delay) / 0.4)
                    .clamp(0.0, 1.0);
                return Opacity(
                  opacity: progress,
                  child: Transform.translate(
                    offset: Offset(30 * (1 - progress), 0),
                    child: child,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        recipe.ingredients[i],
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInstructions(Recipe recipe) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instructions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(recipe.instructions.length, (i) {
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        recipe.instructions[i],
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
