import 'package:complaint_portal/features/auth/bloc/auth_bloc.dart';
import 'package:complaint_portal/features/auth/repository/auth_repository.dart';
import 'package:complaint_portal/features/sector_admin_home/bloc/sector_admin_home_bloc.dart';
import 'package:complaint_portal/features/sector_admin_home/repository/sector_admin_home_repository.dart';
import 'package:complaint_portal/features/super_admin_home/bloc/super_admin_home_bloc.dart';
import 'package:complaint_portal/features/super_admin_home/repository/super_admin_home_repository.dart';
import 'package:complaint_portal/features/technician_home/bloc/technician_home_bloc.dart';
import 'package:complaint_portal/features/technician_home/repository/technician_home_repository.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies()async {
  _initAuth();
  _initTechnicianHome();
  _initSuperAdminHome();
  _initSectorAdminHome();
}

void _initAuth(){
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepository());
  serviceLocator.registerLazySingleton(()=> AuthBloc(authRepository: serviceLocator()));
}

void _initTechnicianHome(){
  serviceLocator.registerLazySingleton<TechnicianHomeRepository>(() => TechnicianHomeRepository());
  serviceLocator.registerLazySingleton(()=> TechnicianHomeBloc(technicianRepository: serviceLocator()));
}

void _initSuperAdminHome(){
  serviceLocator.registerLazySingleton<SuperAdminHomeRepository>(() => SuperAdminHomeRepository());
  serviceLocator.registerLazySingleton(()=> SuperAdminHomeBloc(superAdminHomeRepository: serviceLocator()));
}

void _initSectorAdminHome(){
  serviceLocator.registerLazySingleton<SectorAdminHomeRepository>(() => SectorAdminHomeRepository());
  serviceLocator.registerLazySingleton(()=> SectorAdminHomeBloc(sectorAdminHomeRepository: serviceLocator()));
}