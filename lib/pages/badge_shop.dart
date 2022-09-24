import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lexp/core/res/app.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/models/book.dart';
import 'package:lexp/models/user.dart';
import 'package:lexp/models/user_book.dart';
import 'package:lexp/pages/book_view.dart';
import 'package:lexp/widgets/circle_gradient_icon.dart';
import 'package:lexp/widgets/gradient_text.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;

class BadgeShopScreen extends StatefulWidget {
  const BadgeShopScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<StatefulWidget> createState() {
    return _BadgeShopScreenState();
  }
}

class _BadgeShopScreenState extends State<BadgeShopScreen> {
  late final Future _future;
  late final Future _getBooks;
  late final Future _getMyBooks;
  late final Future _getUser;
  late List<BookModel> _books;
  late List<UserBookModel> _myBooks;
  late List<BookModel> _filteredBooks;
  late UserModel userLXP;

  @override
  void initState() {
    var params = {
      "data": {"idUser": widget.user.idUser}
    };
    _getUser = rest.RestProvider().callMethod("/uc/gubi", params);
    _getUser.then((value) {
      userLXP = UserModel.fromJson(value.data["data"]);
    });
    _getBooks = rest.RestProvider().callMethod("/bc/gab");
    _getBooks.then((value) => {
          _books = shared.SharedService().getBooks(value),
        });
    _getMyBooks = rest.RestProvider().callMethod("/ubc/gabu", params);
    _getMyBooks.then((value) => {
          _myBooks = shared.SharedService().getBuyedBooks(value),
          _filteredBooks = _books.where((element) => !_myBooks.any((element2) => element2.idBook == element.idBook)).toList(),
        });
    _future = Future.wait([_getBooks, _getMyBooks, _getUser]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                if (snapshot.error.toString().contains("SocketException")) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off,
                          size: 100,
                          color: AppColors.customPurple,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "No hay conexión con el servidor",
                          style: TextStyle(
                            color: AppColors.customPurple,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 100,
                          color: AppColors.customPurple,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Ha ocurrido un error inesperado",
                          style: TextStyle(
                            color: AppColors.customPurple,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
              if (snapshot.hasData) {
                return Scaffold(
                    appBar: AppBar(
                      bottom: TabBar(
                        tabs: [
                          Tab(
                            child: Text("Tienda", style: TextStyle(color: AppColors.customPurple)),
                          ),
                          Tab(
                            child: Text("Mis libros", style: TextStyle(color: AppColors.customPurple)),
                          ),
                        ],
                      ),
                      title: GradientText(
                        "Insignias",
                        gradient: AppColors.textGradient,
                      ),
                      actions: [
                        Center(child: Text(userLXP.numberOfCups.toString(), style: TextStyle(color: AppColors.customPurple, fontSize: 20))),
                        Icon(Icons.emoji_events, color: AppColors.customPurple),
                        AppConstants.spacew
                      ],
                    ),
                    body: TabBarView(children: [
                      _buildBookBody(context, _filteredBooks),
                      _buildBookBody(context, _myBooks.map((e) => e.book!).toList(), buyed: true),
                    ]));
              } else {
                return Center(
                    child: Container(
                        color: AppColors.drawerColor,
                        child: SpinKitFadingCube(
                          color: AppColors.customPurple,
                          size: 42.0,
                        )));
              }
            }));
  }

  Widget _buildBookBody(BuildContext context, List<BookModel> books, {bool buyed = false}) {
    return Stack(
      children: [
        GridView.builder(
            itemCount: books.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: EdgeInsets.only(
                      top: index % 2 == 0 ? 10 : 10,
                      right: index % 2 == 0 ? 5 : 20,
                      left: index % 2 == 1 ? 5 : 20,
                      bottom: index % 2 == 1 ? 10 : 10),
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              AppColors.degradedImage1Color,
                              const Color.fromARGB(255, 4, 201, 194),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 5))]),
                      child: Column(
                        children: [
                          Expanded(
                              child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  child: CachedNetworkImage(
                                    imageUrl: books[index].portrait,
                                    placeholder: (context, url) => SpinKitFadingCube(
                                      color: AppColors.customPurple,
                                      size: 30,
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  )),
                              Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: buyed
                                      ? CircleGradientIcon(
                                          color: AppColors.customPinkCyan,
                                          icon: Icons.visibility,
                                          size: 42,
                                          iconSize: 24,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => BookViewScreen(
                                                          book: books[index],
                                                        )));
                                          },
                                        )
                                      : CircleGradientIcon(
                                          color: AppColors.customPinkCyan,
                                          icon: Icons.shopping_cart,
                                          size: 42,
                                          iconSize: 24,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text("¿Desea comprar el libro ${books[index].bookname} a ${books[index].badgeCost}🏆?"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text("Cancelar")),
                                                      TextButton(
                                                          onPressed: () {
                                                            _buyBook(books[index], userLXP, context);
                                                          },
                                                          child: const Text("Comprar")),
                                                    ],
                                                  );
                                                });
                                          },
                                        )),
                              Positioned(
                                bottom: 15,
                                right: 10,
                                child: Text(
                                  "${books[index].badgeCost}🏆",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ],
                          )),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  books[index].bookname,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          )
                        ],
                      )));
            }),
      ],
    );
  }

  void _buyBook(BookModel book, UserModel user, BuildContext context) async {
    var params = {
      "data": {"idUser": user.idUser, "idBook": book.idBook}
    };
    var paramsUser = {
      "data": {"email": user.email}
    };
    rest.RestProvider().callMethod("/ubc/sub", params).then(
        (value) => {
              Navigator.of(context).pop(),
              rest.RestProvider().callMethod("/bc/gab").then(
                    (valueUpper) => {
                      setState(() {
                        _books = shared.SharedService().getBooks(valueUpper);
                      }),
                      rest.RestProvider().callMethod("/ubc/gabu", params).then((value) => {
                            setState(() {
                              _myBooks = shared.SharedService().getBuyedBooks(value);
                              _filteredBooks =
                                  _books.where((element) => !_myBooks.any((element2) => element2.idBook == element.idBook)).toList();
                            }),
                            rest.RestProvider().callMethod("/uc/gube", paramsUser).then((userFetch) {
                              UserModel userAux = UserModel.fromJson(userFetch.data["data"]);
                              shared.SharedService().saveUser("user", user);
                              setState(() {
                                userLXP = userAux;
                              });
                            }, onError: (error) {
                              SnackBar snackBar = SnackBar(
                                content: Text('Error al recuperar el usuario $error'),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            })
                          }),
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("¡Libro comprado con éxito!"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Aceptar")),
                              ],
                            );
                          })
                    },
                  )
            }, onError: (error) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: (error.toString().contains("Not enough"))
                  ? const Text("No tienes suficientes medallas para comprar este libro")
                  : const Text("Ha ocurrido un error al comprar el libro"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Aceptar")),
              ],
            );
          });
    });
  }
}
