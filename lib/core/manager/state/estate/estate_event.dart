part of 'estate_bloc.dart';

sealed class EstateEvent extends Equatable {
  const EstateEvent();
}

class FetchEstateTypesEvent extends EstateEvent {
  @override
  List<Object?> get props => [];
}

class FetchEstateEvent extends EstateEvent {
  final FilterEstateRequest? dto;

  const FetchEstateEvent({this.dto});

  @override
  List<Object?> get props => [dto];
}

class FetchDetailEstateEvent extends EstateEvent {
  final int id;

  const FetchDetailEstateEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
