import 'package:bookmark/core/utils/cached_network_image.dart';
import 'package:bookmark/core/utils/search_shimmer.dart';
import 'package:bookmark/core/utils/sized_box.dart';
import 'package:bookmark/core/view_models/base/base_change_notifier_model.dart';
import 'package:bookmark/core/view_models/users_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UsersViewModel>(
      builder: (context, model, child) {
        return Column(
          children: [
            model.state == BaseViewState.Busy
                ? Expanded(child: SearchShimmer())
                : model.mainUsersList.length == 0 &&
                        model.searchEditController.text.length > 0
                    ? Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "No Search Results Found",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: RefreshIndicator(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: model.mainUsersList.length ?? 0,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 15.0),
                                  child: Card(
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              child: model.mainUsersList[index]
                                                          .avatarUrl ==
                                                      null
                                                  ? loaderBeforeImage(
                                                      image:
                                                          "assets/images/not_found.jpg",
                                                      height: 50.0,
                                                      width: 50.0)
                                                  : networkImage(
                                                      image: model
                                                                  .mainUsersList[
                                                                      index]
                                                                  .avatarUrl !=
                                                              null
                                                          ? model
                                                              .mainUsersList[
                                                                  index]
                                                              .avatarUrl
                                                          : "",
                                                      height: 50.0,
                                                      width: 50.0,
                                                    ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                              height: 10,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    model.mainUsersList[index]
                                                            .login ??
                                                        "",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                  ),
                                                  verticalSizedBoxFive(),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                await model
                                                    .updateBookMark(index);
                                              },
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                    Icons.book_outlined,
                                                    size: 20,
                                                    color: model
                                                            .mainUsersList[
                                                                index]
                                                            .bookMarkStatus
                                                        ? Colors.green
                                                        : Colors.black26,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            onRefresh: () {
                              return Future.delayed(Duration(seconds: 1), () {
                                model.getUsersFromApi();
                              });
                            }),
                      )
          ],
        );
      },
    );
  }
}
