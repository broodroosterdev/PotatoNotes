import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final CustomSearchDelegate delegate;

  SearchPage({@required this.delegate});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState<T> extends State<SearchPage> {
  // This node is owned, but not hosted by, the search page. Hosting is done by
  // the text field.
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.delegate._queryTextController.addListener(_onQueryChanged);
    widget.delegate._focusNode = focusNode;
  }

  @override
  void dispose() {
    super.dispose();
    widget.delegate._queryTextController.removeListener(_onQueryChanged);
    widget.delegate._focusNode = null;
    focusNode.dispose();
  }

  void _onQueryChanged() {
    setState(() {
      // rebuild ourselves because query changed.
    });
  }

  void _onSearchBodyChanged() {
    setState(() {
      // rebuild ourselves because search body changed.
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);
    final String searchFieldLabel = widget.delegate.searchFieldLabel ??
        MaterialLocalizations.of(context).searchFieldLabel;
    Widget body = widget.delegate.buildResults(context);
    String routeName;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        routeName = '';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        routeName = searchFieldLabel;
    }

    return Semantics(
      explicitChildNodes: true,
      scopesRoute: true,
      namesRoute: true,
      label: routeName,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: TextField(
              controller: widget.delegate._queryTextController,
              focusNode: focusNode,
              decoration: InputDecoration.collapsed(
                hintText: "Search",
              ),
              onChanged: (value) => _onSearchBodyChanged(),
            ),
          ),
          actions: widget.delegate.buildActions(context),
        ),
        body: body,
      ),
    );
  }
}

abstract class CustomSearchDelegate<T> {
  CustomSearchDelegate({
    this.searchFieldLabel,
    this.keyboardType,
    this.textInputAction = TextInputAction.search,
  });

  Widget buildResults(BuildContext context);

  List<Widget> buildActions(BuildContext context);

  String get query => _queryTextController.text;
  set query(String value) {
    assert(query != null);
    _queryTextController.text = value;
  }

  void close(BuildContext context) {
    _focusNode?.unfocus();
    Navigator.of(context)..pop();
  }

  final String searchFieldLabel;

  final TextInputType keyboardType;

  final TextInputAction textInputAction;

  Animation<double> get transitionAnimation => _proxyAnimation;

  FocusNode _focusNode;

  final TextEditingController _queryTextController = TextEditingController();

  final ProxyAnimation _proxyAnimation =
      ProxyAnimation(kAlwaysDismissedAnimation);
}