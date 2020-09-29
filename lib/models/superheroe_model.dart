class SuperHeroe{
  int _id;
  String _name;
  int _power;

  SuperHeroe({int id,String name,int power}){
    this._id = id;
    this._name = name;
    this._power = power;
  }
  
  int get id => this._id;
  String get name => this._name;
  int get power => this._power;

  set id(int id){
    this._id = id;
  }
  set name(String name){
    this._name = name;
  }
  set power(int power){
    this._power = power;
  }
}