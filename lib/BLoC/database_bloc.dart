import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_app/DataLayer/user_symbol.dart';

import '../DataLayer/database_repository_impl.dart';

part 'database_event.dart';

part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  final DatabaseRepository _databaseRepository;

  DatabaseBloc(this._databaseRepository) : super(DatabaseInitial()) {
    on<DatabaseFetched>(_fetchUserData);
    on<DatabaseRemoveEvent>(_databaseRemoveEvent);
    on<DatabaseAddEvent>(_databaseAddEvent);
    on<DatabaseBack>(_databaseBackEvent);
  }

  _fetchUserData(DatabaseFetched event, Emitter<DatabaseState> emit) async {
    List<UserSymbol> listofUserData =
        await _databaseRepository.retrieveUserData(event.display);
    emit(DatabaseSuccess(listofUserData, event.display));
  }

  _databaseRemoveEvent(DatabaseRemoveEvent event, Emitter<DatabaseState> emit) async {
    await _databaseRepository.deleteUserData(event.email, event.symbol);
    emit(DatabaseInitial());
  }

  _databaseAddEvent(DatabaseAddEvent event, Emitter<DatabaseState> emit) async {
    await _databaseRepository.saveUserData(event.userSymbol);
    emit(DatabaseInitial());
  }

  _databaseBackEvent(DatabaseBack event, Emitter<DatabaseState> emit) async {
    emit(DatabaseInitial());
  }

}
