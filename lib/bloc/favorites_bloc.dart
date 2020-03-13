import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../data/favorites_data.dart';
import 'bloc.dart';

class FavoritesBloc extends Bloc {
  final FavoritesRepository favoritesRepository;
  final _favoritesController = BehaviorSubject<Set<int>>.seeded({});
  final _favoriteItemController = StreamController<int>();

  Stream<Set<int>> get favorites => _favoritesController.stream;
  Sink<int> get favoriteItem => _favoriteItemController.sink;

  FavoritesBloc(this.favoritesRepository);

  @override
  void dispose() {
    _favoritesController.close();
  }

  @override
  void init() async {
    _favoriteItemController.stream.listen(_updateFavorites);
    try {
      final favorites = await favoritesRepository.fetchFavorites();
      _favoritesController.sink.add(favorites);
    } on Exception catch (e) {
      print(e);
      //TODO: handle exception
    }
  }

  void _updateFavorites(int id) async {
    try {
      final favorites = await favoritesRepository.updateFavorites(id);
      _favoritesController.sink.add(favorites);
    } on Exception catch (e) {
      print(e);
      //TODO: handle exception
    }
  }
}
