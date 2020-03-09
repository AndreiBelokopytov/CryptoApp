import 'package:flutter/widgets.dart';
import '../bloc/bloc.dart';

class BlocProvider<T extends Bloc> extends StatefulWidget {
  final Widget child;
  final T bloc;

  const BlocProvider({Key key, @required this.bloc, @required this.child})
    : super(key: key);

  static T of<T extends Bloc>(BuildContext context) {
    final provider = context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return provider.bloc;
  }

  @override
  State createState() => _BlocProviderState();
}

class _BlocProviderState extends State<BlocProvider> {
  @override
  Widget build(BuildContext context) => widget.child;


  @override
  void initState() {
    super.initState();
    widget.bloc.init();
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}