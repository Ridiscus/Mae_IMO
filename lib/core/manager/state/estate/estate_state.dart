part of 'estate_bloc.dart';

class EstateState extends Equatable {
  final bool? isLoading;
  final Failure? failure;
  final List<EstateTypeModel>? estatesType;
  final List<EstateModel>? estates;
  final EstateModel? estate;
  final ApiPaginateResponse<EstateModel>? paginate;

  const EstateState({
    this.estatesType,
    this.isLoading,
    this.paginate,
    this.failure,
    this.estate,
    this.estates,
  });

  @override
  List<Object?> get props => [
    estatesType,
    isLoading,
    failure,
    estates,
    paginate,
    estate,
  ];

  EstateState copyWith({
    bool? isLoading = true,
    List<EstateModel>? estates,
    ApiPaginateResponse<EstateModel>? paginate,
    List<EstateTypeModel>? estatesType,
    Failure? failure,
    EstateModel? estate,
  }) => EstateState(
    isLoading: isLoading ?? this.isLoading,
    estates: estates ?? this.estates,
    paginate: paginate ?? this.paginate,
    estatesType: estatesType ?? this.estatesType,
    failure: failure,
    estate: estate,
  );

  factory EstateState.fromJson(Map<String, dynamic> json) {
    return EstateState(
      estatesType:
          json['estatesType'] == null
              ? []
              : List<EstateTypeModel>.from(
                json['estatesType'].map((x) => EstateTypeModel.fromMap(x)),
              ),

      estates:
          json['estates'] == null
              ? []
              : List<EstateModel>.from(
                json['estates'].map((x) => EstateModel.fromMap(x)),
              ),
    );
  }

  Map<String, dynamic> toJson() => {
    "estatesType": estatesType?.map((x) => x.toJson()).toList(),
    "estates": estates?.map((x) => x.toJson()).toList(),
  };
}

final class EstateInitial extends EstateState {
  @override
  List<Object> get props => [];
}
