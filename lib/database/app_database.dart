import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//Classe responsável por gerenciar o banco de dados
class AppDatabase {
  //Cria uma instância privada do banco de dados
  static final AppDatabase _instance = AppDatabase._internal();

  // Armazena a instância do banco de dados
  static Database? _database;

  //Construtor da fábrica que retorna sempre a mesma instância
  factory AppDatabase() {
    return _instance;
  }

  //Método para inicializar o banco de dados
  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /*
  Método de inicialização do banco de dados, definindo o caminho e criasndo 
  ou abrindo as tabelas necessárias
  */
  Future<Database> _initDatabase() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, 'app_database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {},
    );
  }
}
