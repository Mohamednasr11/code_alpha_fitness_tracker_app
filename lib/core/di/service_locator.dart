import 'package:get_it/get_it.dart';
import '../../features/exercise_library/data/datasourcse/exercise_local_datasource.dart';
import '../../features/exercise_library/data/repoImpl/exercise_repo_impl.dart';
import '../../features/exercise_library/domain/repos/exercise.dart';
import '../../features/exercise_library/domain/usecases/exercise.dart';
import '../../features/exercise_library/presentation/cubit/exercise_cubit.dart';
import '../../features/work_generator/data/usecases/generated_workout_usecase.dart';
import '../../features/work_generator/presentation/cubits/generator_cubit.dart';
import '../../features/work_log/data/datasources/workout_local_datasource.dart';
import '../../features/work_log/data/repoImp/workout_repo_impl.dart';
import '../../features/work_log/domain/repos/workout_repository.dart';
import '../../features/work_log/domain/usecases/add_set_use_case.dart';
import '../../features/work_log/domain/usecases/create_session_usecase.dart';
import '../../features/work_log/domain/usecases/delete_session_usecase.dart';
import '../../features/work_log/domain/usecases/get_sessions_usecase.dart';
import '../../features/work_log/presentation/cubits/workout_cubit.dart';
import '../../features/work_progress/data/progress_local_datasource.dart';
import '../../features/work_progress/data/repoImpl/progress_repo_impl.dart';
import '../../features/work_progress/domain/repos/progress_repo.dart';
import '../../features/work_progress/domain/usecases/get_progress_usecase.dart';
import '../../features/work_progress/presentation/cubits/progress_cubit.dart';
import '../database/database_helper.dart';
import '../theme/cubit/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerSingleton<DatabaseHelper>(DatabaseHelper.instance);

  sl.registerLazySingleton<ExerciseLocalDatasource>(
    () => ExerciseLocalDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<ExerciseRepository>(
    () => ExerciseRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetExercisesUsecase(sl()));
  sl.registerFactory(() => ExerciseCubit(sl()));

  sl.registerLazySingleton<ProgressLocalDatasource>(
    () => ProgressLocalDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProgressUsecase(sl()));

  sl.registerLazySingleton(() => ProgressCubit(sl()));

  sl.registerLazySingleton<WorkoutLocalDatasource>(
    () => WorkoutLocalDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => CreateSessionUsecase(sl()));
  sl.registerLazySingleton(() => AddSetUsecase(sl()));
  sl.registerLazySingleton(() => GetSessionsUsecase(sl()));
  sl.registerLazySingleton(() => DeleteSessionUsecase(sl()));

  sl.registerLazySingleton(() => WorkoutCubit(
        createSession: sl(),
        addSet: sl(),
        getSessions: sl(),
        deleteSession: sl(),
        progressCubit: sl<ProgressCubit>(),
      ));
  sl.registerLazySingleton(()=>ThemeCubit());

  sl.registerLazySingleton(() => GenerateWorkoutUsecase());
  sl.registerFactory(() => GeneratorCubit(sl()));
}
