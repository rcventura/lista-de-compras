import 'package:flutter/material.dart';
import 'package:lista_compras/core/routes/routes.dart';
import '../../../core/helpers/validators.dart';
import '../../../components/toastAlert/toastAlert.dart';
import '../../../components/SMButtom/SMButtom.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/shoppinglist_bloc.dart';
import '../bloc/shoppinglist_event.dart';
import '../bloc/shoppinglist_state.dart';

class AddNameShoppingListScreen extends StatefulWidget {
  const AddNameShoppingListScreen({super.key});

  @override
  State<AddNameShoppingListScreen> createState() =>
      _AddNameShoppingListScreenState();
}

class _AddNameShoppingListScreenState extends State<AddNameShoppingListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameTextFieldController = TextEditingController();
  final _nameSuperMarketTextFieldController = TextEditingController();
  List<DropdownMenuItem<String>> items = [
    const DropdownMenuItem(value: 'Casa', child: Text('Casa')),
    const DropdownMenuItem(value: 'Mercado', child: Text('Mercado')),
  ];
  String? _selectedValue;

  @override
  void dispose() {
    _nameTextFieldController.dispose();
    _nameSuperMarketTextFieldController.dispose();
    super.dispose();
  }

  Future<void> _createShoppingList() async {
    final nameList = _nameTextFieldController.text;
    final locationList = _selectedValue ?? '';
    final supermarketName = _nameSuperMarketTextFieldController.text;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.read<ShoppinglistBloc>().add(
      CreateShoppingListRequested(name: nameList, location: locationList, supermarketName: supermarketName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<ShoppinglistBloc, ShoppingListState>(
          listener: (context, state) {
            if (state is ShoppingListCreationSuccess) {
              Navigator.pushReplacementNamed(
                context,
                Routes.shoppingListDetail,
              );
            }

            if (state is ShoppingListFetchError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },

          builder: (context, state) {
            final isLoading = state is ShoppingListLoading;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      spacing: 30,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Vamos adicionar o nome e o local onde sua lista esta sendo criada.',
                          textAlign: TextAlign.center,
                        ),

                        TextFormField(
                          controller: _nameTextFieldController,
                          decoration: const InputDecoration(
                            labelText: 'Nome da lista',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          validator: Validators.required,
                        ),

                        DropdownButtonFormField<String>(
                          initialValue: _selectedValue,
                          items: items,
                          onChanged: (value) =>
                              setState(() => _selectedValue = value),
                          decoration: const InputDecoration(
                            labelText: 'Selecione o local',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          validator: Validators.required,
                        ),

                        if (_selectedValue == 'Mercado')
                          TextFormField(
                            controller: _nameSuperMarketTextFieldController,
                            autofocus: true,
                            decoration: const InputDecoration(
                              labelText: 'Nome do supermercado',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                            ),
                            validator: Validators.required,
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: SMButton(
                        text: 'Criar lista',
                        onPressed: _createShoppingList,
                        isLoading: isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
