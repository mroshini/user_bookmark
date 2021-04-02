import 'dart:async';

import 'package:bookmark/core/api_db_models/users_data_model.dart';
import 'package:bookmark/core/api_helper/app_exception.dart';
import 'package:bookmark/core/repositories/user_data_repository.dart';
import 'package:bookmark/core/view_models/base/base_change_notifier_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class UsersViewModel extends BaseChangeNotifierModel {
  UserDataSourceRepository _userDataSourceRepository;
  UsersList searchedDataApiModelResponse;
  int pageNo = 1;
  List<User> _users = [];
  List<User> _bookMarkUsers = [];
  TextEditingController searchEditController;
  TextEditingController searchBookMarkEditController;
  FocusNode searchTextFocus;
  FocusNode searchBookMarkFocus;
  Timer searchOnStoppedTyping;
  bool isTextChanging = false;

  List<User> get mainUsersList => _users;

  List<User> get bookMarkUsersList => _bookMarkUsers;

  UsersViewModel({@required userDataSourceRepository})
      : _userDataSourceRepository = userDataSourceRepository;

  initControllers() {
    searchEditController = TextEditingController();
    searchBookMarkEditController = TextEditingController();
    searchTextFocus = FocusNode();
    searchBookMarkFocus = FocusNode();
  }

  Future<void> getUsersFromApi({int pageLimit}) async {
    _users = await _userDataSourceRepository.getCachedUsersList();
    if (_users.isEmpty) {
      setState(BaseViewState.Busy);
    }
    try {
      final users = await _userDataSourceRepository.initUsersApiCall();
      await setUsersData(users);
    } on BadRequestException {
      setState(BaseViewState.Error);
    } finally {
      setState(BaseViewState.Idle);
    }
  }

  setUsersData(List<User> user) async {
    _users = user;

    notifyListeners();
  }

  onChangeHandler(String query, BuildContext mContext, int type) async {
    const duration = Duration(milliseconds: 300);
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping.cancel();
    }
    isTextChanging = true;
    searchOnStoppedTyping = Timer(duration, () {
      if (type == 0) {
        searchQuery(
          query ?? '',
          mContext,
          isChanged: true,
        );
      } else {
        searchBookMarkQuery(
          query ?? '',
          mContext,
          isChanged: true,
        );
      }
    });
    notifyListeners();
  }

  searchBookMarkQuery(String query, BuildContext mContext,
      {bool isChanged = false}) async {
    //await loadFromCache(query);
    if (searchBookMarkEditController.text.isEmpty) {
      clearBookMarkDataAndUnFocus(mContext);
    } else {}
    if (query.isNotEmpty && query != null && query.length > 2) {
      await loadBookMarkUser(query);
      notifyListeners();
    } else {}
  }

  loadBookMarkUser(String query) async {
    _bookMarkUsers.clear();

    await _userDataSourceRepository.getCachedUsersList().then((value) {
      value.forEach((element) {
        if (query == "" && element.bookMarkStatus == true) {
          _bookMarkUsers.add(element);
        }
        if (element.login.contains(query) && element.bookMarkStatus == true) {
          _bookMarkUsers.add(element);
        }
      });
    });
  }

  searchQuery(String query, BuildContext mContext,
      {bool isChanged = false}) async {
    if (searchEditController.text.isEmpty) {
      clearDataAndUnFocus(mContext);
    } else {}
    if (query.isNotEmpty && query != null && query.length > 2) {
      await loadFromCache(query);
    } else {}
  }

  loadFromCache(String query) async {
    _users.clear();
    await _userDataSourceRepository.getCachedUsersList().then((value) {
      value.forEach((element) {
        if (element.login.contains(query)) {
          _users.add(element);
        }
      });
    });
    notifyListeners();
  }

  clearBookMarkDataAndUnFocus(BuildContext mContext) async {
    await _userDataSourceRepository.getCachedUsersList().then((value) {
      value.forEach((element) {
        if (element.bookMarkStatus == true) {
          _bookMarkUsers.add(element);
        }
      });
    });
    searchBookMarkFocus.unfocus();
    isTextChanging = false;
    setState(BaseViewState.Idle);
    FocusScope.of(mContext).requestFocus(null);
    notifyListeners();
  }

  clearDataAndUnFocus(BuildContext mContext) async {
    _users = await _userDataSourceRepository.getCachedUsersList();
    searchTextFocus.unfocus();
    isTextChanging = false;
    setState(BaseViewState.Idle);
    FocusScope.of(mContext).requestFocus(null);
    notifyListeners();
  }

  updateBookMark(index) async {
    _users[index].bookMarkStatus = true;

    _bookMarkUsers.clear();
    await _userDataSourceRepository
        .updateBookMark(index, _users[index])
        .then((value) async => {
              await setUsersData(value),
              _users.forEach((element) {
                if (element.bookMarkStatus) {
                  _bookMarkUsers.add(element);
                }
              })
            });
  }

  removeBookMark(int index) async {
    _bookMarkUsers[index].bookMarkStatus = false;

    await _userDataSourceRepository
        .removeBookMark(index, _bookMarkUsers[index])
        .then((value) async => {
              await setUsersData(value),
            });

    _bookMarkUsers.removeAt(index);
  }

  @override
  void dispose() {
    Hive.close();
    searchEditController.dispose();
    searchTextFocus.dispose();
    super.dispose();
  }
}
