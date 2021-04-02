import 'package:bookmark/core/api_db_models/users_data_model.dart';
import 'package:bookmark/core/api_helper/api_service_helper.dart';
import 'package:bookmark/core/repositories/user_data_repository_base.dart';
import 'package:bookmark/core/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class UserDataSourceRepository implements UserDataSourceRepositoryBase {
  ApiService apiServiceHelper;

  BuildContext context;
  Box _usersDataBox;

  List<User> usersDataResponse;
  bool initialized = false;

  UserDataSourceRepository(this.context) {
    apiServiceHelper = Provider.of<ApiService>(context, listen: false);
  }

  @override
  Future<List<User>> updateBookMark(int index, User user) async {
    await init();

    usersDataResponse = _usersDataBox.values.toList();
    usersDataResponse.asMap().forEach((key, value) {
      if (user.avatarUrl == value.avatarUrl) {
        _usersDataBox.putAt(
            key,
            User(
                avatarUrl: value.avatarUrl,
                bookMarkStatus: true,
                login: value.login));
      }
    });
    return _usersDataBox.values.toList();
  }

  @override
  Future<List<User>> removeBookMark(int index, User user) async {
    await init();

    usersDataResponse = _usersDataBox.values.toList();
    usersDataResponse.asMap().forEach((key, value) {
      if (user.avatarUrl == value.avatarUrl) {
        _usersDataBox.putAt(
            key,
            User(
                avatarUrl: value.avatarUrl,
                bookMarkStatus: false,
                login: value.login));
      }
    });
    return _usersDataBox.values.toList();
  }

  @override
  Future<void> init() async {
    if (!initialized) {
      Hive.registerAdapter(UsersListAdapter());
      Hive.registerAdapter(UserAdapter());
      initialized = true;
    }
    await initBox();
  }

  @override
  initBox() async {
    try {
      if (_usersDataBox != null && _usersDataBox.isOpen) {
        _usersDataBox = Hive.box<User>(Constants.usersBox);
      } else {
        _usersDataBox = await Hive.openBox<User>(Constants.usersBox);
      }
    } catch (e) {
      _usersDataBox = await Hive.openBox<User>(Constants.usersBox);
    }
  }

  @override
  Future<void> cacheUsersList(List<User> users) async {
    // check if already data exists in box and then update new data
    await init();
    await _usersDataBox.clear();
    await _usersDataBox.addAll(users);
  }

  @override
  Future<List<User>> initUsersApiCall() async {
    try {
      await apiServiceHelper.getHttp().then((response) async {
        usersDataResponse = userFromMap(response.toString());

        await cacheUsersList(usersDataResponse);
      });
      return usersDataResponse;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<User>> getCachedUsersList() async {
    await init();
    usersDataResponse = _usersDataBox.values.toList();
    return usersDataResponse;
  }
}
