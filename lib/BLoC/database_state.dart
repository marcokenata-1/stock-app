part of 'database_bloc.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object?> get props => [];
}

class DatabaseInitial extends DatabaseState {}

class DatabaseRemove extends DatabaseState {}

class DatabaseSuccess extends DatabaseState {
  final List<UserSymbol> listOfUserData;
  final String? displayName;
  const DatabaseSuccess(this.listOfUserData,this.displayName);

  @override
  List<Object?> get props => [listOfUserData,displayName];
}

class DatabaseError extends DatabaseState {
  @override
  List<Object?> get props => [];
}