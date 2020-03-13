import 'favorites_data.dart';

class MockFavoritesRepository extends FavoritesRepository {
  final _favorites = <int>{};

  @override
  Future<Set<int>> fetchFavorites() {
    return Future.value(_favorites);
  }

  @override
  Future<Set<int>> updateFavorites(int id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    return Future.value(_favorites);
  }
}
