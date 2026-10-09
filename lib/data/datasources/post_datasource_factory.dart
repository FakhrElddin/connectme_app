import 'package:connectme_app/data/datasources/firestore_post_datasource.dart';
import 'package:connectme_app/data/datasources/local_post_datasource.dart';
import 'package:connectme_app/data/datasources/post_datasource.dart';

enum PostDatasourceType { remote, local }

/// Design Pattern: Factory Pattern
/// Where applied:
/// [PostDatasourceFactory] provides a centralized factory method [create] to instantiate
/// the appropriate [PostDatasource] implementation ([FirestorePostDatasourceImpl] or [LocalPostDatasourceImpl])
/// based on the specified [PostDatasourceType].
///
/// Why applied:
/// Decouples client components and repository implementations from concrete data source
/// classes, enabling seamless switching between remote Firestore and offline local cache
/// without modifying business or repository logic.
class PostDatasourceFactory {
  static PostDatasource create(PostDatasourceType type) {
    switch (type) {
      case PostDatasourceType.remote:
        return FirestorePostDatasourceImpl();
      case PostDatasourceType.local:
        return LocalPostDatasourceImpl();
    }
  }
}
