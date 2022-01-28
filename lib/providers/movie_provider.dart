import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/models/movie.dart';
import 'package:peliculas_app/models/now_playing_response.dart';
import 'package:peliculas_app/widgets/widgets.dart';

class MoviesProvider extends ChangeNotifier {
  String _baseUrl = 'api.themoviedb.org';
  String _apiKey = 'e004100e22a5fbbdd936eeb7b88eaace';
  String _language = 'es-Es';

  MoviesProvider() {
    //print('initilized');
    getOnDisplayMovies();
    getPopularMovies();
  }

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  int _popularPage = 0;

  Future<String> _getJSONData(String endpoint, [int page = 1]) async {
    var url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, '': _language, 'page': '$page'});
    final response = await http.get(url);
    //if (response.statusCode != 200) return print('error');
    return response.body;
  }

  getOnDisplayMovies() async {
    final json = await _getJSONData('3/movie/now_playing');
    final npr = NowPlayingResponse.fromJson(
        json); // final Map<String, dynamic> decodedData = json.decode(response.body); // as Map<String, dynamic>;
    onDisplayMovies = [...npr.results];

    // Para avisar a los widgets que están suscritos y así poder redibujar los cambios
    notifyListeners();
  }

  void getPopularMovies() async {
    _popularPage++;
  print('gpm $_popularPage');
    final json = await _getJSONData('3/movie/popular', _popularPage);
    final pr = PopularResponse.fromJson(
        json); // final Map<String, dynamic> decodedData = json.decode(response.body); // as Map<String, dynamic>;
    popularMovies = [...popularMovies, ...pr.results];

    // Para avisar a los widgets que están suscritos y así poder redibujar los cambios
    notifyListeners();
  }
}
