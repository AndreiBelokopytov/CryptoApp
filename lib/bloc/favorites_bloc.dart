import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';

class FavoritesBloc extends Bloc {
  final _favoritesController = BehaviorSubject<Set<int>>.seeded({});
  final _favoriteItemController = StreamController<int>();

  Stream<Set<int>> get favorites => _favoritesController.stream;
  Sink<int> get favoriteItem => _favoriteItemController.sink;

  @override
  void dispose() {
    _favoritesController.close();
  }

  @override
  void init() {
    _favoriteItemController.stream.listen(_addToFavorites);
  }

  void _addToFavorites(int id) {
    final lastFavorites = _favoritesController.value;
    if (lastFavorites.contains(id)) {
      lastFavorites.remove(id);
    } else {
      lastFavorites.add(id);
    }
    _favoritesController.sink.add(lastFavorites);
  }
}
