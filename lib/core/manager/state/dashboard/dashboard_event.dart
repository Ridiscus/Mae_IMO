part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class FetchTenantDashboardEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

class FetchAgentDashboardEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

class FetchCommercialDashboardEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

class FetchCommercialAgencesEvent extends DashboardEvent {
  const FetchCommercialAgencesEvent();
  @override
  List<Object?> get props => [];
}

class FetchCommercialOwnersEvent extends DashboardEvent {
  const FetchCommercialOwnersEvent();
  @override
  List<Object?> get props => [];
}

class FetchCommercialPropertiesEvent extends DashboardEvent {
  const FetchCommercialPropertiesEvent();
  @override
  List<Object?> get props => [];
}

class ContactAgencyEvent extends DashboardEvent {
  final ContactAgencyRequest dto;

  const ContactAgencyEvent({required this.dto});
  @override
  List<Object?> get props => [dto];
}

class CreateAgencyEvent extends DashboardEvent {
  final String name;
  final String email;
  final String contact;
  final String commune;
  final String adresse;
  final String rccm;
  final String dfe;
  final File? rib;
  final File? rccmFile;
  final File? dfeFile;
  final File? profileImage;

  const CreateAgencyEvent({
    required this.name,
    required this.email,
    required this.contact,
    required this.commune,
    required this.adresse,
    required this.rccm,
    required this.dfe,
    this.rib,
    this.rccmFile,
    this.dfeFile,
    this.profileImage,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    contact,
    commune,
    adresse,
    rccm,
    dfe,
    rib,
    rccmFile,
    dfeFile,
    profileImage,
  ];
}

class CreateOwnerEvent extends DashboardEvent {
  final String name;
  final String prenom;
  final String email;
  final String contact;
  final String commune;
  final String adresse;
  final File? profileImage;
  final File? cniFile;

  const CreateOwnerEvent({
    required this.name,
    required this.prenom,
    required this.email,
    required this.contact,
    required this.commune,
    required this.adresse,
    this.profileImage,
    this.cniFile,
  });

  @override
  List<Object?> get props => [
    name,
    prenom,
    email,
    contact,
    commune,
    adresse,
    profileImage,
    cniFile,
  ];
}

class CreateAgencyPropertyEvent extends DashboardEvent {
  final String agenceId;
  final String type;
  final String utilisation;
  final String description;
  final double superficie;
  final int avance;
  final int caution;
  final double prix;
  final String commune;
  final String disponibilite;
  final int nombreDeChambres;
  final int nombreDeToilettes;
  final bool garage;
  final int frais;
  final String? video3d;
  final File? mainImage;
  final List<File?>? additionalImages;

  const CreateAgencyPropertyEvent({
    required this.agenceId,
    required this.type,
    required this.utilisation,
    required this.description,
    required this.superficie,
    required this.avance,
    required this.caution,
    required this.prix,
    required this.commune,
    required this.disponibilite,
    required this.nombreDeChambres,
    required this.nombreDeToilettes,
    required this.garage,
    required this.frais,
    this.video3d,
    this.mainImage,
    this.additionalImages,
  });

  @override
  List<Object?> get props => [
    agenceId,
    type,
    utilisation,
    description,
    superficie,
    avance,
    caution,
    prix,
    commune,
    disponibilite,
    nombreDeChambres,
    nombreDeToilettes,
    garage,
    frais,
    video3d,
    mainImage,
    additionalImages,
  ];
}

class CreateOwnerPropertyEvent extends DashboardEvent {
  final String ownerId;
  final String type;
  final String utilisation;
  final String description;
  final double superficie;
  final int avance;
  final int caution;
  final double prix;
  final String commune;
  final String disponibilite;
  final int nombreDeChambres;
  final int nombreDeToilettes;
  final bool garage;
  final int frais;
  final String video3d;
  final File? mainImage;
  final List<File?>? additionalImages;

  const CreateOwnerPropertyEvent({
    required this.ownerId,
    required this.type,
    required this.utilisation,
    required this.description,
    required this.superficie,
    required this.avance,
    required this.caution,
    required this.prix,
    required this.commune,
    required this.disponibilite,
    required this.nombreDeChambres,
    required this.nombreDeToilettes,
    required this.garage,
    required this.frais,
    required this.video3d,
    this.mainImage,
    this.additionalImages,
  });

  @override
  List<Object?> get props => [
    ownerId,
    type,
    utilisation,
    description,
    superficie,
    avance,
    caution,
    prix,
    commune,
    disponibilite,
    nombreDeChambres,
    nombreDeToilettes,
    garage,
    frais,
    video3d,
    mainImage,
    additionalImages,
  ];
}

class UpdatePropertyEvent extends DashboardEvent {
  final dynamic propertyId;
  final String type;
  final String utilisation;
  final String description;
  final double superficie;
  final int avance;
  final int caution;
  final double prix;
  final String commune;
  final String disponibilite;
  final int nombreDeChambres;
  final int nombreDeToilettes;
  final bool garage;
  final int frais;
  final String? video3d;
  final String? paymentDay;
  final File? mainImage;
  final List<File?>? additionalImages;

  const UpdatePropertyEvent({
    required this.propertyId,
    required this.type,
    required this.utilisation,
    required this.description,
    required this.superficie,
    required this.avance,
    required this.caution,
    required this.prix,
    required this.commune,
    required this.disponibilite,
    required this.nombreDeChambres,
    required this.nombreDeToilettes,
    required this.garage,
    required this.frais,
    this.video3d,
    this.paymentDay,
    this.mainImage,
    this.additionalImages,
  });

  @override
  List<Object?> get props => [
    propertyId,
    type,
    utilisation,
    description,
    superficie,
    avance,
    caution,
    prix,
    commune,
    disponibilite,
    nombreDeChambres,
    nombreDeToilettes,
    garage,
    frais,
    video3d,
    paymentDay,
    mainImage,
    additionalImages,
  ];
}

class UpdateAgencyEvent extends DashboardEvent {
  final dynamic id;
  final String name;
  final String email;
  final String contact;
  final String commune;
  final String adresse;
  final String rccm;
  final String dfe;
  final File? rib;
  final File? rccmFile;
  final File? dfeFile;
  final File? profileImage;

  const UpdateAgencyEvent({
    required this.id,
    required this.name,
    required this.email,
    required this.contact,
    required this.commune,
    required this.adresse,
    required this.rccm,
    required this.dfe,
    this.rib,
    this.rccmFile,
    this.dfeFile,
    this.profileImage,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    contact,
    commune,
    adresse,
    rccm,
    dfe,
    rib,
    rccmFile,
    dfeFile,
    profileImage,
  ];
}

class UpdateOwnerEvent extends DashboardEvent {
  final dynamic id;
  final String name;
  final String prenom;
  final String email;
  final String contact;
  final String commune;
  final String adresse;
  final File? profileImage;
  final File? cniFile;
  final File? ribFile;

  const UpdateOwnerEvent({
    required this.id,
    required this.name,
    required this.prenom,
    required this.email,
    required this.contact,
    required this.commune,
    required this.adresse,
    this.profileImage,
    this.cniFile,
    this.ribFile,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    prenom,
    email,
    contact,
    commune,
    adresse,
    profileImage,
    cniFile,
    ribFile,
  ];
}

class DeletePropertyEvent extends DashboardEvent {
  final dynamic id;
  const DeletePropertyEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class DeleteAgencyEvent extends DashboardEvent {
  final dynamic id;
  const DeleteAgencyEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class DeleteOwnerEvent extends DashboardEvent {
  final dynamic id;
  const DeleteOwnerEvent(this.id);
  @override
  List<Object?> get props => [id];
}
