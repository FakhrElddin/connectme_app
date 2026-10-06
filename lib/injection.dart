import 'package:connectme_app/data/datasources/firestore_post_datasource.dart';
import 'package:connectme_app/data/repositories/post_repository_impl.dart';
import 'package:connectme_app/domain/repositories/post_repository.dart';
import 'package:connectme_app/domain/usecases/create_post.dart';
import 'package:connectme_app/domain/usecases/get_posts.dart';
import 'package:connectme_app/presentation/blocs/auth_cubit.dart';
import 'package:connectme_app/presentation/blocs/post_cubit.dart';
import 'package:connectme_app/presentation/blocs/profile_cubit.dart';
import 'package:connectme_app/services/auth_service.dart';
import 'package:connectme_app/services/firestore_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void diInit() {
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(authService: getIt<AuthService>()),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(),
  );
  getIt.registerFactory<PostCubit>(
    () => PostCubit(
      getPostsUsecase: getIt<GetPosts>(),
      createPostUsecase: getIt<CreatePost>(),
    ),
  );
  getIt.registerFactory<GetPosts>(
    () => GetPosts(postRepository: getIt<PostRepository>()),
  );
  getIt.registerFactory<CreatePost>(
    () => CreatePost(postRepository: getIt<PostRepository>()),
  );
  getIt.registerFactory<PostRepository>(
    () => PostRepositoryImpl(
      firestorePostDatasource: getIt<FirestorePostDatasource>(),
    ),
  );
  getIt.registerFactory<FirestorePostDatasource>(
    () => FirestorePostDatasourceImpl(),
  );
}
