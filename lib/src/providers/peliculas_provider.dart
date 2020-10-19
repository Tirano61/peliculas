import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apiKey = '5f9fa986b151658b0beb1b81fe5671f0';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

/*Hay que cerrar si o si el Stream con este metodo
el cual, existe lo cierra si no no hace nada */
  void diposeStem() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final respuesta = await http.get(url);
    final decoderData = json.decode(respuesta.body);
    final peliculas = new Peliculas.fromJsonList(decoderData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getENCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
    });
    return await _procesarRespuesta(url);
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key': _apiKey,
      'language': _language,
    });
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final cast = Cast.fromJsonList(decodeData['cast']);
    
    return cast.actores;
  }

  Future<List<Pelicula>> getPopulares() async {
    //Es para controlar que solo se haga la peticion una vez cuando se mueve el scroll al final
    if (_cargando) return [];
    _cargando = true;
    _popularesPage++;

    print('cargando siguientes');

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString(),
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;
    return resp;
  }


  Future<List<Pelicula>> getbuscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query'   : query,
    });
    return await _procesarRespuesta(url);
  }

}
