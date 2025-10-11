part of 'inventories_bloc.dart';

sealed class InventoriesEvent extends Equatable {
  const InventoriesEvent();
}

class FetchInventoriesEvent extends InventoriesEvent {
  @override
  List<Object?> get props => [];
}

class FetchOneInventoriesEvent extends InventoriesEvent {
  final String id;

  const FetchOneInventoriesEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class GenerateCodeEtatLieuxEvent extends InventoriesEvent {
  final int locataireId;

  const GenerateCodeEtatLieuxEvent({required this.locataireId});

  @override
  List<Object?> get props => [locataireId];
}

class VerifyCodeEtatLieuxEvent extends InventoriesEvent {
  final int locataireId;
  final String verificationCode;

  const VerifyCodeEtatLieuxEvent({
    required this.locataireId,
    required this.verificationCode,
  });

  @override
  List<Object?> get props => [locataireId, verificationCode];
}

class SaveEstateLocationEvent extends InventoriesEvent {
  final SaveEstateLocationRequest request;

  const SaveEstateLocationEvent({required this.request});

  @override
  List<Object?> get props => [request];
}
