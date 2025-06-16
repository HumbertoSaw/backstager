import 'package:backstager/components/sidebar-menu-component.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _firstBuild = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (_firstBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scaffoldKey.currentState?.openDrawer();
        _scaffoldKey.currentState?.closeDrawer();
        _firstBuild = false;
      });
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Pantalla Principal')),
      drawer: SidebarMenuComponent(),
      body: Center(child: Text('Bienvenido a la pantalla principal')),
    );
  }
}
