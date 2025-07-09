import 'package:complaint_portal/features/auth/bloc/auth_bloc.dart';
import 'package:complaint_portal/features/auth/repository/auth_repository.dart';
import 'package:complaint_portal/features/technician_home/bloc/technician_home_bloc.dart';
import 'package:complaint_portal/features/technician_home/repository/technician_home_repository.dart';
import 'package:get_it/get_it.dart';
import 'features/sector_admin_home/repository/auth_repository.dart' as sector_admin_repo;
import 'features/sector_admin_home/bloc/auth_bloc.dart' as sector_admin_bloc;

final serviceLocator = GetIt.instance;

Future<void> initDependencies()async {
  _initAuth();
  _initTechnicianHome();
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
void _initSectorAdminHome() {
  serviceLocator.registerLazySingleton<sector_admin_repo.AuthRepository>(() => sector_admin_repo.AuthRepository());
  serviceLocator.registerLazySingleton<sector_admin_bloc.AuthBloc>(
        () => sector_admin_bloc.AuthBloc(
      authRepository: serviceLocator<sector_admin_repo.AuthRepository>(),
    ),
  );
}