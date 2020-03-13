abstract class FavoritesRepository {
  Future<Set<int>> fetchFavorites();
  Future<Set<int>> updateFavorites(int id);
}