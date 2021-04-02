import 'package:bookmark/core/api_db_models/users_data_model.dart';

abstract class UserDataSourceRepositoryBase {
  Future<void> init();

  Future<void> initBox();

  Future<void> cacheUsersList(List<User> users);

  Future<List<dynamic>> initUsersApiCall();

  Future<List<User>> removeBookMark(int index, User user);

  Future<List<User>> updateBookMark(int index, User user);

  Future<List<User>> getCachedUsersList();
}
