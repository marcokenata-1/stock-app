import 'package:stock_app/DataLayer/user_symbol.dart';

import 'database_service.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  DatabaseService service = DatabaseService();

  @override
  Future<void> saveUserData(UserSymbol user) {
    return service.addUserData(user);
  }

  @override
  Future<List<UserSymbol>> retrieveUserData(String email) {
    return service.retreiveUserData(email);
  }

  @override
  Future<void> deleteUserData(String email, String symbol) {
    return service.deleteUserData(email, symbol);
  }
}

abstract class DatabaseRepository {
  Future<void> saveUserData(UserSymbol user);

  Future<List<UserSymbol>> retrieveUserData(String email);

  Future<void> deleteUserData(String email, String symbol);
}
