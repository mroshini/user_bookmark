import 'package:bookmark/core/view_models/users_view_model.dart';
import 'package:bookmark/ui/routes/book_mark_users.dart';
import 'package:bookmark/ui/routes/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UsersViewModel usersViewModel;

  @override
  void initState() {
    usersViewModel = Provider.of<UsersViewModel>(context, listen: false);
    usersViewModel.getUsersFromApi();
    usersViewModel.initControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersViewModel>(builder: (context, model, child) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                "BookMark",
                style: Theme.of(context).textTheme.headline2,
              ),
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.person_outline),
                    text: "Users",
                  ),
                  Tab(
                      icon: Icon(Icons.book_outlined),
                      text: "Bookmarked Users"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(
                            5.0,
                          ),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            controller: model.searchEditController,
                            focusNode: model.searchTextFocus,
                            textInputAction: TextInputAction.search,
                            onChanged: (value) async {
                              await model.onChangeHandler(
                                  model.searchEditController.text, context, 0);
                            },
                            onEditingComplete: () async {
                              await model.searchQuery(
                                  model.searchEditController.text, context);
                            },
                            onFieldSubmitted: (term) async {
                              model.searchTextFocus.unfocus();
                              await model.searchQuery(
                                  model.searchEditController.text, context);
                            },
                            style: Theme.of(context).textTheme.headline4,
                            decoration: InputDecoration(
                              hintText: "Search here",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                              suffixIcon: Visibility(
                                visible: model.isTextChanging,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    model.searchEditController.text = "";
                                    model.clearDataAndUnFocus(context);
                                  },
                                ),
                              ),
                              prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: UsersScreen()),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(
                            5.0,
                          ),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            controller: model.searchBookMarkEditController,
                            focusNode: model.searchBookMarkFocus,
                            textInputAction: TextInputAction.search,
                            onChanged: (value) async {
                              await model.onChangeHandler(
                                  model.searchBookMarkEditController.text,
                                  context,
                                  1);
                            },
                            onEditingComplete: () async {
                              await model.searchQuery(
                                  model.searchBookMarkEditController.text,
                                  context);
                            },
                            onFieldSubmitted: (term) async {
                              model.searchTextFocus.unfocus();
                              await model.searchQuery(
                                  model.searchBookMarkEditController.text,
                                  context);
                            },
                            style: Theme.of(context).textTheme.headline4,
                            decoration: InputDecoration(
                              hintText: "Search here",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                              suffixIcon: Visibility(
                                visible: model.isTextChanging,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    model.searchBookMarkEditController.text =
                                        "";
                                    model.clearBookMarkDataAndUnFocus(context);
                                  },
                                ),
                              ),
                              prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: BookMarkUsersScreen()),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<bool> _onWillPop() {
    AlertDialog alert = AlertDialog(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      title: Text(
        'Are you sure you want to exit the app?',
        style: Theme.of(context).textTheme.headline4,
      ),
      actions: [
        new TextButton(
          onPressed: () async {
            Navigator.of(context).pop(true);
          },
          child: new Text(
            'Yes',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        new TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: new Text(
            'No',
            style: Theme.of(context).textTheme.headline4,
          ),
        )
      ],
    );

    return showDialog(
          context: context,
          builder: (context) => alert,
        ) ??
        false;
  }
}
