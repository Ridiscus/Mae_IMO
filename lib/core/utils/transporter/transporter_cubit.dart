import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'transporter_interface.dart';

part 'transporter_state.dart';

/// [T] représente le type de la donnée qui sera transportée.
/// T doit implémenter TransporterInterface pour permettre la copie des valeurs
class TransporterCubit<T extends TransporterInterface<T>>
    extends Cubit<TransporterState<T>> {
  static TransporterCubit<T> get<T extends TransporterInterface<T>>(
    BuildContext context,
  ) => context.read<TransporterCubit<T>>();

  TransporterCubit() : super(TransporterInitial<T>());

  /// Initialise ou remplace la valeur du transporteur avec une première valeur.
  void init({required T value}) {
    if (kDebugMode) {
      print("init Type ${T.toString()}");
    }
    emit(TransporterUpdate<T>(value: value));
  }

  void clean() {
    emit(TransporterInitial<T>());
  }

  /// La fonction [updateFn] reçoit la valeur actuelle et retourne une nouvelle valeur.
  void update({required T Function(T? currentValue) updateFn}) {
    final T newValue = updateFn(state.value);
    emit(TransporterUpdate<T>(value: newValue));
  }

  T? get value => state.value;
}
