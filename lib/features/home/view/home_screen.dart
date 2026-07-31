import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lista_compras/components/Alert/ConfirmationAlert.dart';
import 'package:lista_compras/components/BottomSheet/OptionsButtomSheet.dart';
import 'package:lista_compras/components/BottomSheet/PersonButtomSheet.dart';
import 'package:lista_compras/components/toastAlert/toastAlert.dart';
import 'package:lista_compras/core/routes/routes.dart';
import 'package:lista_compras/features/auth/bloc/auth_bloc.dart';
import 'package:lista_compras/features/auth/bloc/auth_state.dart';
import 'package:lista_compras/features/home/bloc/home_bloc.dart';
import 'package:lista_compras/features/home/bloc/home_event.dart';
import 'package:lista_compras/features/home/bloc/home_state.dart';
import 'package:lista_compras/features/home/domain/entities/home_entity.dart';
import 'package:lista_compras/features/shopping/cubit/current_shopping_list_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc _homeBloc = HomeBloc();
  final _searchController = TextEditingController();
  var _clearButtonVisible = false;
  List<HomeEntity> searchItemList = [];
  DateTime? firstDateSelected;
  DateTime? endDateSelected;
  bool filterActive = false;

  @override
  void initState() {
    super.initState();
    _homeBloc.add(HomeFetchShoppingListsRequest());
  }

  @override
  void dispose() {
    _homeBloc.close();
    _searchController.dispose();
    super.dispose();
  }

  void resetVariableState() {
    setState(() {
      filterActive = false;
      firstDateSelected = null;
      endDateSelected = null;
    });
    _homeBloc.add(HomeFetchShoppingListsRequest());
  }

  Future<void> _navigateToAddList() async {
    await Navigator.pushNamedAndRemoveUntil<void>(
      context,
      Routes.addShoppingList,
      (route) => route.isFirst,
    );

    if (mounted) {
      _homeBloc.add(HomeFetchShoppingListsRequest());
    }
    resetVariableState();
  }

  void _searchItem(List<HomeEntity> homeShoppingList) {
    final searchText = _searchController.text.toLowerCase();
    if (searchText.isEmpty) {
      searchItemList = homeShoppingList;
    } else {
      searchItemList = homeShoppingList.where((item) {
        return item.name.toLowerCase().contains(searchText);
      }).toList();
    }
  }

  Future<void> _navigateToListDetails(String shoppingListId) async {
    await Navigator.pushNamed(
      context,
      Routes.shoppingListDetail,
      arguments: ShoppingListDetailArgs(shoppingListId: shoppingListId),
    );
  }

  void _clearTextField() {
    _searchController.clear();
    setState(() {
      _clearButtonVisible = false;
    });
  }

  Widget showClearButtom() {
    if (_clearButtonVisible) {
      return IconButton(
        onPressed: _clearTextField,
        icon: Icon(Icons.close, size: 20, color: Colors.grey[600]),
      );
    }
    return const SizedBox.shrink();
  }

  void filterCalendar(DateTime startDate, DateTime endDate) {
    if (filterActive) {
      _homeBloc.add(HomeShoppingListFilterRequest(startDate, endDate));
    }
  }

  void _deleteList(String listID) {
    if (mounted) {
      _homeBloc.add(HomeDeleteShoppingList(listID));
    }
    ToastAlert.show(context, 'Lista excluida com sucesso!');
  }

  String formatarData(DateTime? data) {
    if (data == null) return 'Não selecionada';
    return DateFormat('dd/MM/yyyy').format(data);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (!mounted) return;

            if (state is AuthInitial) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(Routes.login, (route) => false);
            }
          },
        ),
      ],

      child: BlocBuilder<HomeBloc, HomeState>(
        bloc: _homeBloc,
        builder: (context, state) {
          final listas = state is HomeShoppingListFetchSuccess
              ? state.shoppingLists
              : [];

          final isLoading = state is HomeShoppingListLoading;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Lista de Compras'),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.add, color: Colors.black54),
                onPressed: _navigateToAddList,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.person_outline,
                      color: Colors.black54,
                    ),
                    onPressed: () => ShowPersonBottomSheet.show(context),
                  ),
                ),
              ],
            ),
            body: Column(
              spacing: 5,
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(color: Colors.green[50]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // PRIMEIRO CARD - GASTO DO MÊS
                      Container(
                        width: 170,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                const Icon(
                                  Icons.monetization_on,
                                  size: 20,
                                  color: Colors.green,
                                ),
                                Text(
                                  'Gasto do mês',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              height: 60,
                              child: Text(
                                'R\$ 0,00',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // SEGUNDO CARD
                      Container(
                        width: 170,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                const Icon(
                                  Icons.monetization_on,
                                  size: 20,
                                  color: Colors.green,
                                ),
                                Text(
                                  'Gasto do mês',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              height: 60,
                              child: Text(
                                'R\$ 0,00',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 5,
                        children: [
                          Expanded(
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[500]!),
                              ),
                              child: TextFormField(
                                controller: _searchController,
                                maxLines: 1,
                                onChanged: (value) {
                                  setState(() {
                                    if (_searchController.text.isEmpty) {
                                      _clearButtonVisible = false;
                                    } else {
                                      _clearButtonVisible = true;
                                      _searchItem(listas as List<HomeEntity>);
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  hintText: 'Pesquisar',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  suffixIcon: showClearButtom(),
                                ),
                              ),
                            ),
                          ),

                          IconButton(
                            icon: Icon(Icons.calendar_month_outlined),
                            color: Colors.grey[600],
                            iconSize: 24,
                            onPressed: () async {
                              final selectedDate = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              selectedDate == null
                                  ? setState(() {
                                      filterActive = false;
                                      firstDateSelected = DateTime(2000);
                                      endDateSelected = DateTime(2100);
                                      _homeBloc.add(
                                        HomeFetchShoppingListsRequest(),
                                      );
                                    })
                                  : setState(() {
                                      filterActive = true;
                                      firstDateSelected = selectedDate.start;
                                      endDateSelected = selectedDate.end;
                                      filterCalendar(
                                        firstDateSelected ?? DateTime(2000),
                                        endDateSelected ?? DateTime(2100),
                                      );
                                    });
                            },
                          ),
                        ],
                      ),

                      if (filterActive == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    5,
                                    0,
                                    0,
                                    0,
                                  ),
                                  child: Row(
                                    spacing: 50,
                                    children: [
                                      Row(
                                        spacing: 10,
                                        children: [
                                          Text(
                                            'Início: ${formatarData(firstDateSelected)}',
                                          ),
                                          Text(
                                            'Fim: ${formatarData(endDateSelected)}',
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        onPressed: resetVariableState,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : listas.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              searchItemList.isEmpty &&
                                      _searchController.text.isNotEmpty
                                  ? Text(
                                      'Item pesquisado não encontrado.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : filterActive
                                  ? Text(
                                      'Nenhuma lista encontrada no período selecionado.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : Text(
                                      'Nenhuma lista criada ainda.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                              SizedBox(height: 8),
                              if (listas.isEmpty)
                                Text(
                                  'Toque no + para criar uma lista.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            if (listas.isNotEmpty)
                              Container(
                                width: double.infinity,
                                height: 30,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: const Text(
                                  'Minhas Listas',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: RefreshIndicator.adaptive(
                                onRefresh: () async {
                                  _homeBloc.add(
                                    HomeFetchShoppingListsRequest(),
                                  );
                                },
                                child: _searchController.text.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: searchItemList.length,
                                        itemBuilder: (context, index) {
                                          final listSearch =
                                              searchItemList[index];
                                          return ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    listSearch.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  width: 80,
                                                  height: 30,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    '${listSearch.itemsCount} ${listSearch.itemsCount == 1 ? 'Item' : 'Itens'}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          const Color.fromRGBO(
                                                            56,
                                                            142,
                                                            60,
                                                            1,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            subtitle: Text(
                                              DateFormat(
                                                'dd/MM/yyyy hh:mm',
                                              ).format(
                                                listSearch.createdAt.toLocal(),
                                              ),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            trailing: const Icon(
                                              Icons.chevron_right,
                                            ),
                                            onTap: () {
                                              context
                                                  .read<
                                                    CurrentShoppingListCubit
                                                  >()
                                                  .setCurrentList(
                                                    id: listSearch.id,
                                                    name: listSearch.name,
                                                    local: listSearch.local,
                                                    createdAt: listSearch
                                                        .createdAt
                                                        .toIso8601String(),
                                                  );
                                              _navigateToListDetails(
                                                listSearch.id,
                                              );
                                            },
                                            onLongPress: () => OptionsButtomSheet.show(
                                              context,
                                              onDelete: () => ConfirmationAlert(
                                                titleAlert: 'Atenção',
                                                messageAlert:
                                                    'Deseja realmente excluir esta lista de compras?',
                                                onConfirmation: () => {
                                                  _deleteList(listas[index].id),
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : ListView.builder(
                                        itemCount: listas.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    listas[index].name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  width: 80,
                                                  height: 30,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    '${listas[index].itemsCount} ${listas[index].itemsCount == 1 ? 'Item' : 'Itens'}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          const Color.fromRGBO(
                                                            56,
                                                            142,
                                                            60,
                                                            1,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            subtitle: Text(
                                              DateFormat(
                                                'dd/MM/yyyy HH:mm',
                                              ).format(
                                                listas[index].createdAt
                                                    .toLocal(),
                                              ),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            trailing: const Icon(
                                              Icons.chevron_right,
                                            ),
                                            onTap: () {
                                              context
                                                  .read<
                                                    CurrentShoppingListCubit
                                                  >()
                                                  .setCurrentList(
                                                    id: listas[index].id,
                                                    name: listas[index].name,
                                                    local: listas[index].local,
                                                    createdAt: listas[index]
                                                        .createdAt
                                                        .toIso8601String(),
                                                  );

                                              _navigateToListDetails(
                                                listas[index].id,
                                              );
                                            },
                                            onLongPress: () =>
                                                OptionsButtomSheet.show(
                                                  context,

                                                  onDelete: () =>
                                                      ConfirmationAlert.show(
                                                        context,
                                                        'Atenção',
                                                        'Deseja realmente excluir esta lista de compras?',
                                                        () => _deleteList(
                                                          listas[index].id,
                                                        ),
                                                      ),
                                                ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
