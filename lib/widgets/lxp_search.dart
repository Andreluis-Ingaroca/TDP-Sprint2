import 'package:flutter/material.dart';
import 'package:lexp/models/thematic_unit.dart';
import 'package:lexp/models/user.dart';
import 'package:lexp/widgets/results.dart';

class LXPSearch extends SearchDelegate {
  final Object queryLXP;
  final UserModel user;
  LXPSearch(this.queryLXP, this.user);

  void _delegate(queryLXP) {
    if (queryLXP is ThematicUnitModel) {
      //TODO
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            Navigator.pop(context);
          } else {
            query = "";
          }
        },
      )
    ];
  }

  @override
  String get searchFieldLabel => 'Buscar';

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListResultsLXP(query: query, user: user);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
        //TODO: add search suggestions
        );
  }
}
