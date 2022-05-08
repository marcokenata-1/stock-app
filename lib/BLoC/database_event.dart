part of 'database_bloc.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object?> get props => [];
}

class DatabaseFetched extends DatabaseEvent {
  final String display;
  const DatabaseFetched(this.display);

  @override
  List<Object?> get props => [display];
}

class DatabaseAddEvent extends DatabaseEvent {
  final UserSymbol userSymbol;
  const DatabaseAddEvent(this.userSymbol);

  @override
  List<Object?> get props => [userSymbol];
}

class DatabaseRemoveEvent extends DatabaseEvent {
  final String email;
  final String symbol;
  const DatabaseRemoveEvent(this.email, this.symbol);

  @override
  List<Object?> get props => [email, symbol];
}

class DatabaseBack extends DatabaseEvent {

  @override
  List<Object?> get props => [];
}