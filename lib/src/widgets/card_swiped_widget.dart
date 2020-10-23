import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;
  
  //Constructor con parametro requerido
  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    //Con el mediaQuery obtendremos el tamaños de las diferentes pantallas

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 30.0),
      child: Swiper(
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context, int index) {
          //Crea el id unico para que no se confunda con las tarjetas de abajo y
          // poder hacer el Hero animation
          peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';

          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  //Enviar a la pagina Detalle//************************* */

                  onTap: () => Navigator.pushNamed(context, 'detalle',
                      arguments: peliculas[index]),
                  child: FadeInImage(
                    image: NetworkImage(
                      peliculas[index].getPosterImg(),
                    ),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                )),
          );
        },
        itemCount: peliculas.length,
        //Controles que se pueden usar,
          loop: false,
          index: 0,
        //pagination: new SwiperPagination(),
        //control: new SwiperControl(),
      ),
    );
  }
}
