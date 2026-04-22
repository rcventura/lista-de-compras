import 'package:flutter/material.dart';
import 'package:lista_compras/components/BottomSheet/Person/PersonButtomSheet.dart';
import 'package:lista_compras/features/shopping/bloc/detail_shoppinglist_bloc.dart';
import 'package:lista_compras/features/shopping/bloc/detail_shoppinglist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailShoppingListScreen extends StatefulWidget {
  const DetailShoppingListScreen({
    super.key,
    required this.shoppingListId,
    required this.shoppingListName,
    required this.dataCriacao,
  });

  final String shoppingListId;
  final String shoppingListName;
  final DateTime dataCriacao;

  @override
  State<DetailShoppingListScreen> createState() =>
      _DetailShoppingListScreenState();
}

class _DetailShoppingListScreenState extends State<DetailShoppingListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailShoppinglistBloc, DetailShoppinglistState>(
      listener: (context, state) {
        if (state is DetailSShoppingListItemInitial) {
          // Lógica para lidar com o estado inicial dos itens da lista de compras
          Navigator.of(context).pushReplacementNamed('/home');
          // Lógica para lidar com mudanças de estado
        }
      },

      child: BlocBuilder<DetailShoppinglistBloc, DetailShoppinglistState>(
        builder: (context, state) {
          final isLoading = state is DetailSShoppingListItemLoading;
          final listaItem = state is DetailSShoppingListItemFetchSuccess
              ? state.items
              : [];
          // Lógica para construir a UI com base no estado atual
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detalhes da Lista'),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black54),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_outline, color: Colors.black54),
                  onPressed: () => ShowUserModal.show(context),
                ),
              ],
            ),
            body: SafeArea(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 100,
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withValues(
                                          alpha: 0.5,
                                        ),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 1),
                                        // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.shoppingListName),

                                      Text(
                                        'Criada em: ${widget.dataCriacao.toString().split(' ')[0]}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: listaItem.isEmpty
                                      ? Center(
                                          child: Text(
                                            'Nenhum item adicionado à lista.',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: listaItem.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                listaItem[index].name,
                                              ),
                                              subtitle: Text(
                                                'Descrição do item ${index + 1}',
                                              ),
                                              trailing: Icon(
                                                Icons.check_circle_outline,
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              Divider(color: Colors.grey, thickness: 1),

                              SizedBox(
                                width: double.infinity,
                                height: 70,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Total',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'R\$ 100,00',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
