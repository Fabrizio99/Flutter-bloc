import 'package:bloc_project_2/models/superheroe_model.dart';
import 'package:flutter/material.dart';
import 'package:bloc_project_2/superheroe_bloc.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SuperHeroeBloc superHeroeBloc = SuperHeroeBloc();
  Stream snackListener;
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _poderController = TextEditingController();


  @override
  void dispose(){
    superHeroeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    snackListener = superHeroeBloc.snackBarStream;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ejercicio con BLoC'),
        ),
        body: Builder(
          builder: (BuildContext context){
            snackListener.listen((text) { 
              Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(text),
                  ), // SnackBar
                );
            });
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _formWidget(),
                Expanded(
                  child: _listWidget(),
                )
              ],
            );
          }
        )
      ),
    );
  }

  Widget _formWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nombreController,
            decoration: InputDecoration(
              labelText: 'Nombre',
            ),
          ),
          TextField(
            controller: _poderController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              labelText: 'Nivel de Poder',
            ),
          ),
          const SizedBox(height: 10.0),
          ButtonTheme(
            minWidth: double.infinity,
            child: RaisedButton(
              onPressed: _addSuperHeroe,
              child: const Text(
                'Agregar',
                style: TextStyle(color: Colors.white)
              ),
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
  Widget _listWidget(){
    return StreamBuilder<List<SuperHeroe>>(
      stream: superHeroeBloc.superHeroeStream,
      builder: (BuildContext context,AsyncSnapshot<List<SuperHeroe>> snapshot){
        if(!snapshot.hasData){
          return CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor);
        }else{
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context,index){
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('${index+1}'),
                    Text(snapshot.data[index].name),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.red,
                      ), 
                      onPressed: (){
                        superHeroeBloc.decrementPowerSink.add(snapshot.data[index]);
                      }
                    ),
                    Text('${snapshot.data[index].power}'),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_drop_up,
                        color: Colors.green,
                      ), 
                      onPressed: (){
                        superHeroeBloc.incrementPowerSink.add(snapshot.data[index]);
                      }
                    ),
                  ],
                ),
              );
            }
          );
        }
      }
    );
  }

  _addSuperHeroe(){
    if(_nombreController.text.isEmpty || _poderController.text.isEmpty){
      _showAlert('Debe completar los campos');
      return;
    }
    if(int.parse(_poderController.text)<0 || int.parse(_poderController.text)>10){
      _showAlert('Los niveles de poder van de 0 a 10');
      return;
    }

    superHeroeBloc.addSuperHeroeSink.add(
      {
        'name' : _nombreController.text,
        'power' : int.parse(_poderController.text),
      }
    );

    _nombreController.text = '';
    _poderController.text = '';
  }

  void _showAlert(String message){
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Aviso"),
        content: new Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      )
    );
  }
}
