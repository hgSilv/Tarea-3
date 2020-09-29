import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users list"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Filtros'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Pares'),
              onTap: () {
                _homeBloc..add(FilterUsersEvent(filterEven: true));
              },
            ),
            ListTile(
              title: Text('Impares'),
              onTap: () {
                _homeBloc..add(FilterUsersEvent(filterEven: false));
              },
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => _homeBloc..add(GetAllUsersEvent()),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            // para mostrar dialogos o snackbars
            if (state is ErrorState) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text("Error: ${state.error}")),
                );
            }
          },
          builder: (context, state) {
            if (state is ShowUsersState) {
              return RefreshIndicator(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
                  itemCount: state.usersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(state.usersList[index].name),
                      subtitle: Text(state.usersList[index].company.name),
                      trailing: Text(state.usersList[index].address.street +
                          ' ' +
                          state.usersList[index].address.suite +
                          '\n' +
                          state.usersList[index].phone),
                    );
                  },
                ),
                onRefresh: () async {
                  BlocProvider.of<HomeBloc>(context).add(GetAllUsersEvent());
                },
              );
            } else if (state is LoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(
              child: MaterialButton(
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(GetAllUsersEvent());
                },
                child: Text("Cargar de nuevo"),
              ),
            );
          },
        ),
      ),
    );
  }
}
