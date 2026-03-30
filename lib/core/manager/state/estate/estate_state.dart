part of 'estate_bloc.dart';

class EstateState extends Equatable {
  final bool? isLoading;
  final Failure? failure;
  final List<EstateTypeModel>? estatesType;
  final List<EstateModel>? estates;
  final EstateModel? estate;
  final ApiPaginateResponse<EstateModel>? paginate;
  final String? messageResult;
  final Map<String, List<EstateModel>>? cache;

  const EstateState({
    this.estatesType,
    this.isLoading,
    this.paginate,
    this.failure,
    this.estate,
    this.estates,
    this.messageResult,
    this.cache,
  });

  @override
  List<Object?> get props => [
    estatesType,
    isLoading,
    failure,
    estates,
    paginate,
    estate,
    messageResult,
    cache,
  ];

  EstateState copyWith({
    bool? isLoading = false,
    List<EstateModel>? estates,
    ApiPaginateResponse<EstateModel>? paginate,
    List<EstateTypeModel>? estatesType,
    Failure? failure,
    EstateModel? estate,
    String? messageResult,
    Map<String, List<EstateModel>>? cache,
  }) => EstateState(
    isLoading: isLoading ?? this.isLoading,
    estates: estates ?? this.estates,
    paginate: paginate ?? this.paginate,
    estatesType: estatesType ?? this.estatesType,
    estate: estate ?? this.estate,
    failure: failure,
    messageResult: messageResult,
    cache: cache ?? this.cache,
  );

  factory EstateState.fromJson(Map<String, dynamic> json) {
    return EstateState(
      estatesType:
          json['estatesType'] == null
              ? []
              : List<EstateTypeModel>.from(
                json['estatesType'].map((x) => EstateTypeModel.fromJson(x)),
              ),

      estates:
          json['estates'] == null
              ? []
              : List<EstateModel>.from(
                json['estates'].map((x) {
                  if (x is String) return EstateModel.fromJson(x);
                  return EstateModel.fromMap(x as Map<String, dynamic>);
                }),
              ),
      cache:
          json['cache'] == null
              ? {}
              : (json['cache'] as Map<String, dynamic>).map(
                (k, v) => MapEntry(
                  k,
                  List<EstateModel>.from(
                    (v as List).map((x) {
                      if (x is String) return EstateModel.fromJson(x);
                      return EstateModel.fromMap(x as Map<String, dynamic>);
                    }),
                  ),
                ),
              ),
    );
  }

  Map<String, dynamic> toJson() => {
    "estatesType": estatesType?.map((x) => x.toJson()).toList(),
    "estates": estates?.map((x) => x.toJson()).toList(),
    "cache":
        cache?.map((k, v) => MapEntry(k, v.map((x) => x.toJson()).toList())),
  };
}

final class EstateInitial extends EstateState {
  const EstateInitial()
    : super(estatesType: const [], estates: const [], cache: const {});
}
