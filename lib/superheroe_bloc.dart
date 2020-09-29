//imports
import 'dart:async';
import 'package:bloc_project_2/models/superheroe_model.dart';

class SuperHeroeBloc{
  int id = 0;
  //data
  /*List<SuperHeroe> _superHeroeList = [
    SuperHeroe(
        id: 1,
        name: 'Iron Man',
        power : 10
    ),
    SuperHeroe(
        id: 2,
        name: 'Hulk',
        power : 5
    ),
    SuperHeroe(
        id: 3,
        name: 'Spiderman',
        power : 4
    )
  ];*/
  List<SuperHeroe> _superHeroeList = [];

  //streams
  StreamController<List<SuperHeroe>> _superHeroeStreamController = StreamController<List<SuperHeroe>>();
  StreamController<SuperHeroe> _increasePowerSuperHeroeStream = StreamController<SuperHeroe>();
  StreamController<SuperHeroe> _decreasePowerSuperHeroeStream = StreamController<SuperHeroe>();
  StreamController<Map> _addSuperHeroeStreamController = StreamController<Map>();
  StreamController<String> _showSnackBar = StreamController<String>.broadcast();

  //sink and listen
  Stream get superHeroeStream => _superHeroeStreamController.stream;
  StreamSink get incrementPowerSink => _increasePowerSuperHeroeStream.sink;
  StreamSink get decrementPowerSink => _decreasePowerSuperHeroeStream.sink;
  Stream get snackBarStream => _showSnackBar.stream;
  StreamSink get addSuperHeroeSink => _addSuperHeroeStreamController.sink;

  SuperHeroeBloc(){
    _superHeroeStreamController.add(_superHeroeList);
    _increasePowerSuperHeroeStream.stream.listen(_increasePower);
    _decreasePowerSuperHeroeStream.stream.listen(_decreasePower);
    _addSuperHeroeStreamController.stream.listen(_addSuperHeroe);
  }

  _increasePower(SuperHeroe superHeroe){
    int index = _superHeroeList.indexWhere((superH) => superH.id == superHeroe.id);
    if(_superHeroeList[index].power == 10){
      _showSnackBar.add('${_superHeroeList[index].name} ha alcanzado el máximo valor de poder.');
      return;
    }
    ++_superHeroeList[index].power;
    _sortList();
    _superHeroeStreamController.add(_superHeroeList);
  }

  _decreasePower(superHeroe){
    int index = _superHeroeList.indexWhere((superH) => superH.id == superHeroe.id);
    if(_superHeroeList[index].power == 0){
      _showSnackBar.add('${_superHeroeList[index].name} ha alcanzado el mínimo valor de poder.');
      return;
    }
    --_superHeroeList[index].power;
    _sortList();
    _superHeroeStreamController.add(_superHeroeList);
  }

  _addSuperHeroe(Map data){
    _superHeroeList.add(SuperHeroe(id:id,name: data['name'],power: data['power']));
    ++id;
    _sortList();
    _superHeroeStreamController.add(_superHeroeList);
  }

  void _sortList(){
    _superHeroeList.sort((a,b)=>b.power.compareTo(a.power));
  }

  void dispose(){
    _superHeroeStreamController.close();
    _increasePowerSuperHeroeStream.close();
    _decreasePowerSuperHeroeStream.close();
  }
}