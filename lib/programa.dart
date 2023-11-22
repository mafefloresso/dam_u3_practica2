import 'package:dam_u3_practica_2/serviciosremotos.dart';
import 'package:flutter/material.dart';


List claves = ['Titulo','Artista','Genero'];
class AppPractica2 extends StatefulWidget {
  const AppPractica2({super.key});

  @override
  State<AppPractica2> createState() => _AppPractica2State();
}

class _AppPractica2State extends State<AppPractica2> {
  int _index = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BASE CANCION"), centerTitle: true,
      ),
      body: dinamico(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.manage_search), label: "Lista" ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Agregar" )
        ],
        currentIndex: _index,
        onTap: (indice){
          setState(() {
            _index = indice;
          });
        },
      ),

    );
  }
  Widget dinamico(){
    switch(_index){
      case 1: return capturar();
    }
    return mostrarLista();
  }
  final titulo = TextEditingController();
  final artista = TextEditingController();
  final album = TextEditingController();
  final duracion = TextEditingController();
  final genero = TextEditingController();
  final anio = TextEditingController();

  Widget capturar(){
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        TextField(
          controller: titulo,
          decoration: InputDecoration(
              labelText: "Título:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: artista,
          decoration: InputDecoration(
              labelText: "Artista:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: album,
          decoration: InputDecoration(
              labelText: "Álbum:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: duracion,
          decoration: InputDecoration(
              labelText: "Duración:"
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10,),
        TextField(
          controller: genero,
          decoration: InputDecoration(
              labelText: "Género:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: anio,
          decoration: InputDecoration(
              labelText: "Año:"
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: (){
                  var JSonTemporal = {
                    'titulo': titulo.text,
                    'artista': artista.text,
                    'album': album.text,
                    'duracion': int.parse(duracion.text),
                    'genero': genero.text,
                    'anio': int.parse(anio.text),
                  };
                  DB.insertar(JSonTemporal).then((value) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Canción insertada'),
                          content: Text('Se ha insertado: ${titulo.text}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                titulo.text = ''; artista.text = '';
                                album.text = '';duracion.text = '';
                                genero.text = '';anio.text = '';
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
                child: Text("Insertar")
            ),
            ElevatedButton(
                onPressed: (){
                  titulo.text = ''; artista.text = '';
                  album.text = '';duracion.text = '';
                  genero.text = '';anio.text = '';
                  setState(() {
                    _index=0;
                  });
                },
                child: Text("Cancelar")
            ),
          ],
        )
      ],
    );
  }


  String clave = claves.first;
  String claveReal = "";
  String valor = "";
  final controladorG = TextEditingController();
  String reporte = '';
  Widget mostrarLista() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              height: 230,
              child:
              Column(
                  children: [
                    SizedBox(height: 20,),
                    TextField(
                      controller: controladorG,
                      decoration: InputDecoration(
                          labelText: "Buscar:"
                      ),
                    ),
                    SizedBox(height: 10,),
                    DropdownButtonFormField(
                        value: clave,
                        items: claves.map(  (e) {
                          return DropdownMenuItem(child: Text(e), value: e,);
                        }).toList(),
                        onChanged: (item){
                          setState(() {
                            clave = item.toString();
                          });
                        }),
                    SizedBox(height: 10,),
                    FilledButton(
                        onPressed: () {
                          setState(() {
                            valor = controladorG.text;
                            claveReal = clave;
                            FocusScope.of(context).unfocus();
                          });
                        },
                        child: Text("Buscar")),
                    SizedBox(height: 10,),
                    Text("${reporte}",),
                  ]
              ),
            ),
            //CONTENEDOR DE LISTA CON FILTRO
            Container(
              height: 360,
              child: FutureBuilder(
                  future: listaFiltro(),
                  builder: (context, lista) {
                    if (lista.hasData) {
                      return Container(
                        padding: EdgeInsets.all(20),
                        height: 50,
                        child: ListView.builder(
                            itemCount: lista.data?.length,
                            itemBuilder: (context, indice) {
                              return ListTile(
                                title: Text(lista.data?[indice]['titulo']),
                                subtitle: Text("${lista.data?[indice]['artista']}"),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('ELIMINAR'),
                                          content: Text("¿Está seguro?"),
                                          actions: [
                                            TextButton(
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                                },
                                              child: Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                DB
                                                    .eliminar(lista.data?[indice]['id'])
                                                    .then((value) {

                                                });

                                                Navigator.of(context).pop();

                                              },
                                              child: Text('OK'),
                                            )
                                          ],
                                        );
                                      },
                                    );

                                  },
                                ),
                                onTap: () { //art,al, dur, gen, an
                                  String id = "${lista.data?[indice]['id']}";
                                  String titulo = "${lista.data?[indice]['titulo']}";
                                  String artista = "${lista.data?[indice]['artista']}";
                                  String album = "${lista.data?[indice]['album']}";
                                  int duracion =
                                  int.parse("${lista.data?[indice]['duracion']}");
                                  String genero =
                                      "${lista.data?[indice]['genero']}";
                                  int anio =
                                  int.parse("${lista.data?[indice]['anio']}");

                                  actualizar(id, titulo, artista, album, duracion, genero, anio);


                                },
                              );
                            }
                        ),
                      );
                    }
                    return Container(
                      child: CircularProgressIndicator(),
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<List> listaFiltro() async {
    List todos = await DB.mostrarTodos();
    if(valor.isEmpty) {
      setState(() {
        reporte = "Mostrando todas las canciones";
      });
      return todos;
    }
    List listaresultado = [];
    switch(claveReal){
      case "Titulo": { ///artista, genero
        todos.forEach((element) {
          Map<String, dynamic> dato = element as Map<String, dynamic>;
          String cadenaTitulo = dato['titulo'].toString().toLowerCase();
          if (cadenaTitulo.contains(valor.toLowerCase())) {
            listaresultado.add(element);
          }
        });
      }
      case "Artista": { ///artista, genero
        todos.forEach((element) {
          Map<String, dynamic> dato = element as Map<String, dynamic>;
          String cadenaArtista = dato['artista'].toString().toLowerCase();
          if (cadenaArtista.contains(valor.toLowerCase())) {
            listaresultado.add(element);
          }
        });
      }
      case "Genero": { ///artista, genero
        todos.forEach((element) {
          Map<String, dynamic> dato = element as Map<String, dynamic>;
          String cadenaGen = dato['genero'].toString().toLowerCase();
          if (cadenaGen.contains(valor.toLowerCase())) {
            listaresultado.add(element);
          }
        });
      }
      default: {
        todos.forEach((element) {
          if (element[claveReal] == valor) {
            listaresultado.add(element);
          }
        });
      }
    }
    setState(() {
      reporte = "RESULTADO (${listaresultado.length})";
    });
    return listaresultado;
  }

  //actualizar(id, titulo, artista, album, duracion, genero, anio);

  void actualizar(String id, String titulo,String artista,
      String album, int duracion, String genero, int anio) {
    final tituloA = TextEditingController();
    final artistaA = TextEditingController();
    final albumA = TextEditingController();
    final duracionA = TextEditingController();
    final generoA = TextEditingController();
    final anioA = TextEditingController();
    tituloA.text = titulo;
    artistaA.text = artista;
    albumA.text = album;
    duracionA.text = duracion.toString();
    generoA.text = genero;
    anioA.text = anio.toString();

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.only(
                top: 15,
                left: 30,
                right: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom + 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Id: " + id),
                TextField(
                  controller: tituloA,
                  decoration: InputDecoration(
                      labelText: "Titulo:",
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: artistaA,
                  decoration: InputDecoration(
                      labelText: "Artista:",
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: albumA,
                  decoration: InputDecoration(
                      labelText: "Album:",
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: duracionA,
                  decoration: InputDecoration(
                      labelText: "Duracion:",
                      border: OutlineInputBorder()) ,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: generoA,
                  decoration: InputDecoration(
                      labelText: "Genero:",
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: anioA,
                  decoration: InputDecoration(
                      labelText: "Año:",
                      border: OutlineInputBorder()) ,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            var JSonTemporal = {
                              'id': id,
                              'titulo': tituloA.text,
                              'artista': artistaA.text,
                              'album': albumA.text,
                              'duracion': int.parse(duracionA.text),
                              'genero': generoA.text,
                              'anio': int.parse(anioA.text),
                            };
                            DB.actualizar(JSonTemporal);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Canción actualizada'),
                                  content: Text('Se ha actualizado: ${tituloA.text}'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );

                          });
                        },
                        child: Text("ACTUALIZAR")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("CANCELAR")),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
