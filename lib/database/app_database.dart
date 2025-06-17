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
      onCreate: (Database db, int version) async {
        await db.execute('''
            CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            email TEXT UNIQUE,
            password TEXT,
            firstname TEXT,
            lastname TEXT,
            city TEXT,
            street TEXT,
            number INTEGER,
            zipcode TEXT,
            phone TEXT,
            lat TEXT,
            long TEXT,
            )
      ''');

        /* Criando a tabela CART (Representa o carrinho de compra que está 
        associado a um usuário)
        */

        await db.execute('''
            CREATE TABLE IF NOT EXISTS cart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userid INTEGER,
            date TEXT
            )
        ''');

        /*Criando a tabela CARTPRODUCTS (Representa os produtos que o usuário
        irá adicionar no carrinho de compras)
        */

        await db.execute('''
           CREATE TABLE IF NOT EXISTS cart_products (
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           cartid INTEGER,
           productid INTEGER,
           quantity INTEGER,
           title TEXT,
           price REAL,
           imageURL TEXT
           )
        ''');

        /* Criando a tabela favorites (Cada registro será associado a um 
        usuário e um produto)
        */

        await db.execute('''
          CREATE TABLE IF NOT EXISTS favorites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userid INTEGER,
          productid INTEGER,
          date_favorite TEXT
          )
        ''');

        /* Criando a tabela RATING (Irá armazenar as avaliações dos produtos
        por um usuário. Será possível avaliar o produto uma única vez)
        */

        await db.execute('''
          CREATE TABLE IF NOT EXISTS rating (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userid INTEGER,
          productid INTEGER,
          rate REAL,
          count INTEGER,
          UNIQUE (userid, productid)
          )
        ''');

        /* Criando a tabela AUTH (Irá armazenar o token de autenticação e o 
        nome do usuário)
        */

        await db.execute('''
          CREATE TABLE IF NOT EXISTS auth (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT UNIQUE,
          token TEXT
          )
        ''');

        /* Criando a tabela ORDERS (Representa um pedido realizado pelo 
        usuário)
        */

        await db.execute('''
            CREATE TABLE IF NOT EXISTS orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userid INTEGER,
            date TEXT,
            status TEXT
            )
        ''');

        /* Criando a tabela ORDERPRODUCTS (Irá armazenar os produtos que fazem
        parte de cada pedido)
        */

        await db.execute('''
            CREATE TABLE IF NOT EXISTS order_products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderid INTEGER,
            productid INTEGER,
            quantity INTEGER,
            price REAL
            )
        ''');
      },
    );
  }
}
