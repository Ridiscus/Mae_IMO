import 'dart:async';
import 'dart:io';
import 'dart:developer' as console;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';
import 'package:maelys_imo/core/services/dashboard_service.dart';
import 'package:maelys_imo/core/utils/toast/notification_toast.dart';
import 'package:toastification/toastification.dart';
import '../../../utils/index.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends HydratedBloc<DashboardEvent, DashboardState> {
  final DashboardService _service;

  DashboardBloc({required DashboardService service})
    : _service = service,
      super(DashboardInitial()) {
    on<FetchTenantDashboardEvent>(_onFetchTenantDashboardEvent);
    on<ContactAgencyEvent>(_onContactAgencyEvent);
    on<FetchAgentDashboardEvent>(_onFetchAgentDashboardEvent);
    on<FetchCommercialDashboardEvent>(_onFetchCommercialDashboardEvent);
    on<FetchCommercialAgencesEvent>(_onFetchCommercialAgencesEvent);
    on<FetchCommercialOwnersEvent>(_onFetchCommercialOwnersEvent);
    on<FetchCommercialPropertiesEvent>(_onFetchCommercialPropertiesEvent);
    on<CreateAgencyEvent>(_onCreateAgencyEvent);
    on<CreateOwnerEvent>(_onCreateOwnerEvent);
    on<CreateAgencyPropertyEvent>(_onCreateAgencyPropertyEvent);
    on<CreateOwnerPropertyEvent>(_onCreateOwnerPropertyEvent);
    on<UpdatePropertyEvent>(_onUpdatePropertyEvent);
    on<UpdateAgencyEvent>(_onUpdateAgencyEvent);
    on<UpdateOwnerEvent>(_onUpdateOwnerEvent);
    on<DeletePropertyEvent>(_onDeletePropertyEvent);
    on<DeleteAgencyEvent>(_onDeleteAgencyEvent);
    on<DeleteOwnerEvent>(_onDeleteOwnerEvent);
  }

  @override
  DashboardState? fromJson(Map<String, dynamic> json) {
    return DashboardState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(DashboardState state) {
    return state.toJson();
  }

  FutureOr<void> _onFetchCommercialAgencesEvent(
    FetchCommercialAgencesEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.commercialAgences();
      if (result.success) {
        emit(state.copyWith(isLoading: false, agencies: result.data));
      } else {
        showToast(msg: result.message ?? "Données non disponible !");
        emit(
          state.copyWith(
            isLoading: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      console.log(
        "ERROR:: ${e.toString()}",
        name: "_onFetchCommercialAgencesEvent",
      );
      emit(state.copyWith(isLoading: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  FutureOr<void> _onFetchCommercialOwnersEvent(
    FetchCommercialOwnersEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.commercialOwners();
      if (result.success) {
        emit(state.copyWith(isLoading: false, owners: result.data));
      } else {
        showToast(msg: result.message ?? "Données non disponible !");
        emit(
          state.copyWith(
            isLoading: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      console.log(
        "ERROR:: ${e.toString()}",
        name: "_onFetchCommercialOwnersEvent",
      );
      emit(state.copyWith(isLoading: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  FutureOr<void> _onFetchCommercialDashboardEvent(
    FetchCommercialDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.commercialDashboard();
      if (result.success) {
        emit(
          state.copyWith(
            isLoading: false,
            commercialDashboardModel: result.data,
          ),
        );
      } else {
        showToast(msg: result.message ?? "Données non disponible !");
        emit(
          state.copyWith(
            isLoading: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      console.log(
        "ERROR:: ${e.toString()}",
        name: "_onFetchCommercialDashboardEvent",
      );
      emit(state.copyWith(isLoading: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  FutureOr<void> _onFetchTenantDashboardEvent(
    FetchTenantDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.tenantDashboard();
      if (result.success) {
        emit(
          state.copyWith(isLoading: false, tenantDashboardModel: result.data),
        );
      } else {
        showToast(msg: result.message ?? "Données non disponible !");
        emit(
          state.copyWith(
            isLoading: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      console.log(
        "ERROR:: ${e.toString()}",
        name: "_onFetchTenantDashboardEvent",
      );
      emit(state.copyWith(isLoading: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  FutureOr<void> _onContactAgencyEvent(
    ContactAgencyEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.contactAgency(dto: event.dto);
      if (result.success) {
        showToast(
          msg: result.message ?? "Message envoyé avec succès",
          type: ToastificationType.success,
        );
        emit(state.copyWith(isLoading: false, mailSent: true));
      } else {
        showToast(msg: result.message ?? "Message non envoyé");
        emit(
          state.copyWith(
            isLoading: false,
            mailSent: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      console.log("ERROR:: ${e.toString()}", name: "_onContactAgencyEvent");
      showToast(msg: "Échec : Message non envoyé");
      emit(state.copyWith(isLoading: false, mailSent: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  FutureOr<void> _onFetchAgentDashboardEvent(
    FetchAgentDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.agentDashboard();
      if (result.success) {
        emit(
          state.copyWith(isLoading: false, agentDashboardModel: result.data),
        );
      } else {
        showToast(msg: result.message ?? "Données non disponible !");
        emit(
          state.copyWith(
            isLoading: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      console.log(
        "ERROR:: ${e.toString()}",
        name: "_onFetchAgentDashboardEvent",
      );
      emit(state.copyWith(isLoading: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  FutureOr<void> _onFetchCommercialPropertiesEvent(
    FetchCommercialPropertiesEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _service.commercialProperties();
      if (result.success) {
        emit(state.copyWith(isLoading: false, properties: result.data));
      } else {
        showToast(msg: result.message ?? "Données non disponible !");
        emit(
          state.copyWith(
            isLoading: false,
            failure: Failure(message: result.message!),
          ),
        );
      }
    } catch (e) {
      console.log(
        "ERROR:: ${e.toString()}",
        name: "_onFetchCommercialPropertiesEvent",
      );
      emit(state.copyWith(isLoading: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  FutureOr<void> _onCreateAgencyEvent(
    CreateAgencyEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isCreatingAgency: true, agencyCreated: false));
    try {
      final result = await _service.createAgency(
        name: event.name,
        email: event.email,
        contact: event.contact,
        commune: event.commune,
        adresse: event.adresse,
        rccm: event.rccm,
        dfe: event.dfe,
        rib: event.rib,
        rccmFile: event.rccmFile,
        dfeFile: event.dfeFile,
        profileImage: event.profileImage,
      );

      if (result.success) {
        emit(
          state.copyWith(
            isCreatingAgency: false,
            agencyCreated: true,
            formErrors: {},
          ),
        );
        // Optionnel: On peut rafraîchir la liste des agences directement
        add(FetchCommercialAgencesEvent());
      } else {
        final Map<String, dynamic> formErrors = {};
        if (result.errors is Map) {
          final rawErrors = result.errors as Map;
          rawErrors.forEach((key, value) {
            String fieldKey = key.toString();
            if (value is List && value.isNotEmpty) {
              String msg = value[0].toString();
              // Comprehensive translations for common validations
              if (msg.contains("has already been taken")) {
                msg = "Cette valeur est déjà utilisée.";
              } else if (msg.contains("must be a valid email")) {
                msg = "Veuillez entrer une adresse email valide.";
              } else if (msg.contains("required")) {
                msg = "Ce champ est obligatoire.";
              } else if (msg.contains("must be a valid")) {
                msg = "Format invalide.";
              } else if (msg.contains("must be at least")) {
                msg = "Cette valeur est trop courte.";
              } else if (msg.contains("must be at most")) {
                msg = "Cette valeur est trop longue.";
              } else if (msg.contains("invalid")) {
                msg = "Valeur invalide.";
              }
              formErrors[fieldKey] = msg;
            }
          });
        }

        // Only show a toast if we truly have no specific field errors to show
        // and it's not a validation error (e.g. Server Error / Network Error)
        if (formErrors.isEmpty &&
            (result.errors == null ||
                (result.errors is Map && (result.errors as Map).isEmpty))) {
          showToast(
            msg: result.message ?? "Erreur lors de la création de l'agence",
          );
        }

        emit(
          state.copyWith(
            isCreatingAgency: false,
            agencyCreated: false,
            formErrors: formErrors,
            failure: Failure(message: "Validation Error"),
          ),
        );
      }
    } catch (e) {
      console.log("ERROR:: ${e.toString()}", name: "_onCreateAgencyEvent");
      showToast(msg: "Erreur lors de la création de l'agence");
      emit(state.copyWith(isCreatingAgency: false, agencyCreated: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  FutureOr<void> _onCreateOwnerEvent(
    CreateOwnerEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isCreatingOwner: true, ownerCreated: false));
    try {
      final result = await _service.createOwner(
        name: event.name,
        prenom: event.prenom,
        email: event.email,
        contact: event.contact,
        commune: event.commune,
        adresse: event.adresse,
        profileImage: event.profileImage,
        cniFile: event.cniFile,
      );

      if (result.success) {
        emit(
          state.copyWith(
            isCreatingOwner: false,
            ownerCreated: true,
            formErrors: {},
          ),
        );
        add(const FetchCommercialOwnersEvent());
      } else {
        final Map<String, dynamic> formErrors = {};
        if (result.errors is Map) {
          final rawErrors = result.errors as Map;
          rawErrors.forEach((key, value) {
            String fieldKey = key.toString();
            if (value is List && value.isNotEmpty) {
              String msg = value[0].toString();
              // Comprehensive translations for common validations
              if (msg.contains("has already been taken")) {
                msg = "Cette valeur est déjà utilisée.";
              } else if (msg.contains("must be a valid email")) {
                msg = "Veuillez entrer une adresse email valide.";
              } else if (msg.contains("required")) {
                msg = "Ce champ est obligatoire.";
              } else if (msg.contains("must be a valid")) {
                msg = "Format invalide.";
              } else if (msg.contains("must be at least")) {
                msg = "Cette valeur est trop courte.";
              } else if (msg.contains("must be at most")) {
                msg = "Cette valeur est trop longue.";
              } else if (msg.contains("invalid")) {
                msg = "Valeur invalide.";
              }
              formErrors[fieldKey] = msg;
            }
          });
        }

        if (formErrors.isEmpty &&
            (result.errors == null ||
                (result.errors is Map && (result.errors as Map).isEmpty))) {
          showToast(
            msg: result.message ?? "Erreur lors de la création du propriétaire",
          );
        }

        emit(
          state.copyWith(
            isCreatingOwner: false,
            ownerCreated: false,
            formErrors: formErrors,
            failure: Failure(message: "Validation Error"),
          ),
        );
      }
    } catch (e) {
      console.log("ERROR:: ${e.toString()}", name: "_onCreateOwnerEvent");
      showToast(msg: "Erreur lors de la création du propriétaire");
      emit(state.copyWith(isCreatingOwner: false, ownerCreated: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  FutureOr<void> _onCreateAgencyPropertyEvent(
    CreateAgencyPropertyEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isCreatingProperty: true, propertyCreated: false));
    try {
      final result = await _service.createAgencyProperty(
        agenceId: event.agenceId,
        type: event.type,
        utilisation: event.utilisation,
        description: event.description,
        superficie: event.superficie,
        avance: event.avance,
        caution: event.caution,
        prix: event.prix,
        commune: event.commune,
        disponibilite: event.disponibilite,
        nombreDeChambres: event.nombreDeChambres,
        nombreDeToilettes: event.nombreDeToilettes,
        garage: event.garage,
        frais: event.frais,
        video3d: event.video3d,
        mainImage: event.mainImage,
        additionalImages: event.additionalImages,
      );

      if (result.success) {
        emit(
          state.copyWith(
            isCreatingProperty: false,
            propertyCreated: true,
            formErrors: {},
          ),
        );
        add(const FetchCommercialPropertiesEvent());
      } else {
        final Map<String, dynamic> formErrors = {};
        if (result.errors is Map) {
          final rawErrors = result.errors as Map;
          rawErrors.forEach((key, value) {
            String fieldKey = key.toString();
            if (value is List && value.isNotEmpty) {
              String msg = value[0].toString();
              if (msg.contains("has already been taken")) {
                msg = "Cette valeur est déjà utilisée.";
              } else if (msg.contains("must be a valid email")) {
                msg = "Veuillez entrer une adresse email valide.";
              } else if (msg.contains("must not be greater than")) {
                msg = "Fichier trop volumineux (max 2 Mo).";
              } else if (msg.contains("required")) {
                msg = "Ce champ est obligatoire.";
              } else if (msg.contains("must be a valid")) {
                msg = "Format invalide.";
              } else if (msg.contains("must be at least")) {
                msg = "Cette valeur est trop courte.";
              } else if (msg.contains("must be at most")) {
                msg = "Cette valeur est trop longue.";
              } else if (msg.contains("invalid")) {
                msg = "Valeur invalide.";
              }
              formErrors[fieldKey] = msg;
            }
          });
        }

        if (formErrors.isEmpty) {
          showToast(
            msg: result.message ?? "Erreur lors de la création du bien",
          );
        }

        emit(
          state.copyWith(
            isCreatingProperty: false,
            propertyCreated: false,
            formErrors: formErrors,
            failure: Failure(message: "Validation Error"),
          ),
        );
      }
    } catch (e) {
      console.log(
        "ERROR:: ${e.toString()}",
        name: "_onCreateAgencyPropertyEvent",
      );
      showToast(msg: "Erreur lors de la création du bien");
      emit(state.copyWith(isCreatingProperty: false, propertyCreated: false));
    }
  }

  FutureOr<void> _onCreateOwnerPropertyEvent(
    CreateOwnerPropertyEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isCreatingProperty: true, propertyCreated: false));
    try {
      final result = await _service.createOwnerProperty(
        ownerId: event.ownerId,
        type: event.type,
        utilisation: event.utilisation,
        description: event.description,
        superficie: event.superficie,
        avance: event.avance,
        caution: event.caution,
        prix: event.prix,
        commune: event.commune,
        disponibilite: event.disponibilite,
        nombreDeChambres: event.nombreDeChambres,
        nombreDeToilettes: event.nombreDeToilettes,
        garage: event.garage,
        frais: event.frais,
        video3d: event.video3d,
        mainImage: event.mainImage,
        additionalImages: event.additionalImages,
      );

      if (result.success) {
        emit(
          state.copyWith(
            isCreatingProperty: false,
            propertyCreated: true,
            formErrors: {},
          ),
        );
        add(const FetchCommercialPropertiesEvent());
      } else {
        final Map<String, dynamic> formErrors = {};
        if (result.errors is Map) {
          final rawErrors = result.errors as Map;
          rawErrors.forEach((key, value) {
            String fieldKey = key.toString();
            if (value is List && value.isNotEmpty) {
              String msg = value[0].toString();
              if (msg.contains("has already been taken")) {
                msg = "Cette valeur est déjà utilisée.";
              } else if (msg.contains("must be a valid email")) {
                msg = "Veuillez entrer une adresse email valide.";
              } else if (msg.contains("must not be greater than")) {
                msg = "Fichier trop volumineux (max 2 Mo).";
              } else if (msg.contains("required")) {
                msg = "Ce champ est obligatoire.";
              } else if (msg.contains("must be a valid")) {
                msg = "Format invalide.";
              } else if (msg.contains("must be at least")) {
                msg = "Cette valeur est trop courte.";
              } else if (msg.contains("must be at most")) {
                msg = "Cette valeur est trop longue.";
              } else if (msg.contains("invalid")) {
                msg = "Valeur invalide.";
              }
              formErrors[fieldKey] = msg;
            }
          });
        }

        if (formErrors.isEmpty) {
          showToast(
            msg: result.message ?? "Erreur lors de la création du bien",
          );
        }

        emit(
          state.copyWith(
            isCreatingProperty: false,
            propertyCreated: false,
            formErrors: formErrors,
            failure: Failure(message: "Validation Error"),
          ),
        );
      }
    } catch (e) {
      console.log(
        "ERROR:: ${e.toString()}",
        name: "_onCreateOwnerPropertyEvent",
      );
      showToast(msg: "Erreur lors de la création du bien");
      emit(state.copyWith(isCreatingProperty: false, propertyCreated: false));
    }
  }

  FutureOr<void> _onUpdatePropertyEvent(
    UpdatePropertyEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isUpdatingProperty: true, propertyUpdated: false));
    try {
      final result = await _service.updateProperty(
        propertyId: event.propertyId,
        type: event.type,
        utilisation: event.utilisation,
        description: event.description,
        superficie: event.superficie,
        avance: event.avance,
        caution: event.caution,
        prix: event.prix,
        commune: event.commune,
        disponibilite: event.disponibilite,
        nombreDeChambres: event.nombreDeChambres,
        nombreDeToilettes: event.nombreDeToilettes,
        garage: event.garage,
        frais: event.frais,
        video3d: event.video3d,
        paymentDay: event.paymentDay,
        mainImage: event.mainImage,
        additionalImages: event.additionalImages,
      );

      if (result.success) {
        emit(
          state.copyWith(
            isUpdatingProperty: false,
            propertyUpdated: true,
            formErrors: {},
          ),
        );
        add(const FetchCommercialPropertiesEvent());
      } else {
        final Map<String, dynamic> formErrors = {};
        if (result.errors is Map) {
          final rawErrors = result.errors as Map;
          rawErrors.forEach((key, value) {
            String fieldKey = key.toString();
            if (value is List && value.isNotEmpty) {
              String msg = value[0].toString();
              if (msg.contains("has already been taken")) {
                msg = "Cette valeur est déjà utilisée.";
              } else if (msg.contains("must be a valid email")) {
                msg = "Veuillez entrer une adresse email valide.";
              } else if (msg.contains("must not be greater than")) {
                msg = "Fichier trop volumineux (max 2 Mo).";
              } else if (msg.contains("required")) {
                msg = "Ce champ est obligatoire.";
              } else if (msg.contains("must be a valid")) {
                msg = "Format invalide.";
              } else if (msg.contains("must be at least")) {
                msg = "Cette valeur est trop courte.";
              } else if (msg.contains("must be at most")) {
                msg = "Cette valeur est trop longue.";
              } else if (msg.contains("invalid")) {
                msg = "Valeur invalide.";
              }
              formErrors[fieldKey] = msg;
            }
          });
        }

        if (formErrors.isEmpty) {
          showToast(
            msg: result.message ?? "Erreur lors de la modification du bien",
          );
        }

        emit(
          state.copyWith(
            isUpdatingProperty: false,
            propertyUpdated: false,
            formErrors: formErrors,
            failure: Failure(message: "Validation Error"),
          ),
        );
      }
    } catch (e) {
      console.log("ERROR:: ${e.toString()}", name: "_onUpdatePropertyEvent");
      showToast(msg: "Erreur lors de la modification du bien");
      emit(state.copyWith(isUpdatingProperty: false, propertyUpdated: false));
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  FutureOr<void> _onUpdateAgencyEvent(
    UpdateAgencyEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isUpdatingAgency: true, agencyUpdated: false));
    try {
      final result = await _service.updateAgency(
        id: event.id,
        name: event.name,
        email: event.email,
        contact: event.contact,
        commune: event.commune,
        adresse: event.adresse,
        rccm: event.rccm,
        dfe: event.dfe,
        rib: event.rib,
        rccmFile: event.rccmFile,
        dfeFile: event.dfeFile,
        profileImage: event.profileImage,
      );

      if (result.success) {
        emit(
          state.copyWith(
            isUpdatingAgency: false,
            agencyUpdated: true,
            formErrors: {},
          ),
        );
        add(const FetchCommercialAgencesEvent());
      } else {
        final Map<String, dynamic> formErrors = {};
        if (result.errors is Map) {
          final rawErrors = result.errors as Map;
          rawErrors.forEach((key, value) {
            String fieldKey = key.toString();
            if (value is List && value.isNotEmpty) {
              String msg = value[0].toString();
              formErrors[fieldKey] = msg;
            }
          });
        }
        if (formErrors.isEmpty) {
          showToast(
            msg: result.message ?? "Erreur lors de la modification de l'agence",
          );
        }
        emit(
          state.copyWith(
            isUpdatingAgency: false,
            agencyUpdated: false,
            formErrors: formErrors,
            failure: Failure(message: "Validation Error"),
          ),
        );
      }
    } catch (e) {
      console.log("ERROR:: ${e.toString()}", name: "_onUpdateAgencyEvent");
      showToast(msg: "Erreur lors de la modification de l'agence");
      emit(state.copyWith(isUpdatingAgency: false, agencyUpdated: false));
    }
  }

  FutureOr<void> _onUpdateOwnerEvent(
    UpdateOwnerEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isUpdatingOwner: true, ownerUpdated: false));
    try {
      final result = await _service.updateOwner(
        id: event.id,
        name: event.name,
        prenom: event.prenom,
        email: event.email,
        contact: event.contact,
        commune: event.commune,
        adresse: event.adresse,
        profileImage: event.profileImage,
        cniFile: event.cniFile,
        ribFile: event.ribFile,
      );

      if (result.success) {
        emit(
          state.copyWith(
            isUpdatingOwner: false,
            ownerUpdated: true,
            formErrors: {},
          ),
        );
        add(const FetchCommercialOwnersEvent());
      } else {
        final Map<String, dynamic> formErrors = {};
        if (result.errors is Map) {
          final rawErrors = result.errors as Map;
          rawErrors.forEach((key, value) {
            String fieldKey = key.toString();
            if (value is List && value.isNotEmpty) {
              String msg = value[0].toString();
              formErrors[fieldKey] = msg;
            }
          });
        }
        if (formErrors.isEmpty) {
          showToast(
            msg:
                result.message ??
                "Erreur lors de la modification du propriétaire",
          );
        }
        emit(
          state.copyWith(
            isUpdatingOwner: false,
            ownerUpdated: false,
            formErrors: formErrors,
            failure: Failure(message: "Validation Error"),
          ),
        );
      }
    } catch (e) {
      console.log("ERROR:: ${e.toString()}", name: "_onUpdateOwnerEvent");
      showToast(msg: "Erreur lors de la modification du propriétaire");
      emit(state.copyWith(isUpdatingOwner: false, ownerUpdated: false));
    }
  }

  FutureOr<void> _onDeletePropertyEvent(
    DeletePropertyEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isDeletingProperty: true, propertyDeleted: false));
    try {
      final result = await _service.deleteProperty(event.id);
      if (result.success) {
        emit(state.copyWith(isDeletingProperty: false, propertyDeleted: true));
        showToast(
          msg: result.message ?? "Bien supprimé avec succès",
          type: ToastificationType.success,
        );
        add(const FetchCommercialPropertiesEvent());
      } else {
        emit(state.copyWith(isDeletingProperty: false));
        showToast(
          msg: result.message ?? "Erreur lors de la suppression",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      emit(state.copyWith(isDeletingProperty: false));
    }
  }

  FutureOr<void> _onDeleteAgencyEvent(
    DeleteAgencyEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isDeletingAgency: true, agencyDeleted: false));
    try {
      final result = await _service.deleteAgency(event.id);
      if (result.success) {
        emit(state.copyWith(isDeletingAgency: false, agencyDeleted: true));
        showToast(
          msg: result.message ?? "Agence supprimée avec succès",
          type: ToastificationType.success,
        );
        add(const FetchCommercialAgencesEvent());
      } else {
        emit(state.copyWith(isDeletingAgency: false));
        showToast(
          msg: result.message ?? "Erreur lors de la suppression",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      emit(state.copyWith(isDeletingAgency: false));
    }
  }

  FutureOr<void> _onDeleteOwnerEvent(
    DeleteOwnerEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isDeletingOwner: true, ownerDeleted: false));
    try {
      final result = await _service.deleteOwner(event.id);
      if (result.success) {
        emit(state.copyWith(isDeletingOwner: false, ownerDeleted: true));
        showToast(
          msg: result.message ?? "Propriétaire supprimé avec succès",
          type: ToastificationType.success,
        );
        add(const FetchCommercialOwnersEvent());
      } else {
        emit(state.copyWith(isDeletingOwner: false));
        showToast(
          msg: result.message ?? "Erreur lors de la suppression",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      emit(state.copyWith(isDeletingOwner: false));
    }
  }
}
