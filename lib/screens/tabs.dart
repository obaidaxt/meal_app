import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:meal_app/data/dummy_data.dart';
// import 'package:meal_app/models/meal.dart';
import 'package:meal_app/providers/favorites_provider.dart';
import 'package:meal_app/providers/filters_provider.dart';
import 'package:meal_app/providers/meals_provider.dart';
import 'package:meal_app/screens/categories.dart';
import 'package:meal_app/screens/filters.dart';
import 'package:meal_app/screens/meals.dart';
import 'package:meal_app/widgets/main_drawer.dart';

const kInitialfilters= {
    Filter.glutenFree:  false ,
    Filter.lactoseFree:false,
    Filter.vegetarian:false,
    Filter.vegan:false,
  };

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  // final List<Meal> _favoriteMeals = [];
  // Map<Filter,bool> _selectedFilters=kInitialfilters;



  // void _toggleMealFavoriteStatus(Meal meal) {
  //   final isExisting = _favoriteMeals.contains(meal);

  //   if (isExisting) {
  //     setState(() {
  //       _favoriteMeals.remove(meal);
  //     });
  //     _showinfoMessage('Meal is no longer favorite.');
  //   } else {
  //     setState(() {
  //       _favoriteMeals.add(meal);
  //       _showinfoMessage('Marked as a favorite!');
  //     });
  //   }
  // }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async{
    Navigator.of(context).pop();
    if (identifier == 'filters') {
       await Navigator.of(context).push<Map<Filter,bool>>(
        MaterialPageRoute(
          builder: (ctx) => const  FiltersScreen(),
        ),
      );
// setState(() {
  
//       _selectedFilters=result ?? kInitialfilters;
// });
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals=ref.watch(mealsProvider);
    final activeFilters=ref.watch(filterProvider);
    final availiableMeals= meals.where((meal){
      if( activeFilters[Filter.glutenFree]! && !meal.isGlutenFree){
        return false;
      }
      if( activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree){
        return false;
      }
      if( activeFilters[Filter.vegetarian]! && !meal.isVegetarian){
        return false;
      }
      if( activeFilters[Filter.vegan]! && !meal.isVegan){
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      // onToggleFavorite: _toggleMealFavoriteStatus,
      availiableMeals: availiableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
final favoriteMeals= ref.watch(favoriteMealsProvider);      
      activePage = MealsScreen(
        meals: favoriteMeals,
        // onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectSecreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.set_meal), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
