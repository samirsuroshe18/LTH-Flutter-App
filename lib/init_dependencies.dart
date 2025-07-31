import 'package:complaint_portal/features/auth/bloc/auth_bloc.dart';
import 'package:complaint_portal/features/auth/repository/auth_repository.dart';
import 'package:complaint_portal/features/location/bloc/location_bloc.dart';
import 'package:complaint_portal/features/location/repository/location_repository.dart';
import 'package:complaint_portal/features/notice/bloc/notice_bloc.dart';
import 'package:complaint_portal/features/notice/repository/notice_repository.dart';
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
  _initLocation();
  _initNotice();
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

void _initLocation(){
  serviceLocator.registerLazySingleton<LocationRepository>(() => LocationRepository());
  serviceLocator.registerLazySingleton(()=> LocationBloc(locationRepository: serviceLocator()));
}

void _initNotice(){
  serviceLocator.registerLazySingleton<NoticeRepository>(() => NoticeRepository());
  serviceLocator.registerLazySingleton(()=> NoticeBloc(noticeRepository: serviceLocator()));
}