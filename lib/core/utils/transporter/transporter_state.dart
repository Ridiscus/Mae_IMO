part of 'transporter_cubit.dart';


/// T représente le type de donnée transportée.
sealed class TransporterState<T> extends Equatable {
  final T? value;
  
  const TransporterState({this.value});

  @override
  List<Object?> get props => [value];
}

final class TransporterInitial<T> extends TransporterState<T> {
  const TransporterInitial() : super(value: null);
}

final class TransporterUpdate<T> extends TransporterState<T> {
  const TransporterUpdate({required T value}) : super(value: value);
}
