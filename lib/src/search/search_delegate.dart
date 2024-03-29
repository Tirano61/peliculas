
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  final peliculas = ['Spiderman', 'Capitan America', 'Batman', 'Ironman'];
  final peliculasRecientes = ['Spiderman', 'Capitan America'];

  String seleccion = "";

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro appBar

    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    //es solo para mostrar como funciona
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencia que aparecen cuando la persona escribe

    final peliculasProvider = new PeliculasProvider();

    if (query.isEmpty) {
      return Container();
    } else {
      return FutureBuilder(
        future: peliculasProvider.getbuscarPelicula(query),
        builder:
            (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if (snapshot.hasData) {
            final peliculas = snapshot.data;
            return ListView(
                children: peliculas.map((pelicula) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  height: 100.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  close(context, pelicula.uniqueId = '');
                  Navigator.pushNamed(context, 'detalle',
                      arguments: pelicula);
                },
              );
            }).toList());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }
}

// Muestra de la busqueda

// @override
// Widget buildSuggestions(BuildContext context) {
//   // Son las sugerencia que aparecen cuando la persona escribe

//   final listaSugerida = (query.isEmpty)
//       ? peliculasRecientes
//       : peliculas
//           .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
//           .toList();

//   return ListView.builder(
//     itemBuilder: (context, i) {
//       return ListTile(
//         leading: Icon(Icons.movie),
//         title: Text(listaSugerida[i]),
//         onTap: () {
//           //es solo para mostrar como funciona
//           seleccion = listaSugerida[i];
//           showResults(context);
//         },
//       );
//     },
//     itemCount: listaSugerida.length,
//   );
// }
