import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/components/toastAlert/toastAlert.dart';
import 'package:lista_compras/components/SMButtom/SMButtom.dart';
import 'package:lista_compras/core/helpers/enum.dart';
import 'package:lista_compras/core/helpers/validators.dart';
import 'package:lista_compras/features/categories_items/bloc/add_items_in_list_bloc.dart';
import 'package:lista_compras/features/categories_items/bloc/add_items_in_list_event.dart';
import 'package:lista_compras/features/categories_items/bloc/categories_items_bloc.dart';
import 'package:lista_compras/features/categories_items/bloc/categories_items_state.dart';
import 'package:lista_compras/features/shopping/bloc/create_detail_item_shoppinglist_event.dart';
import 'package:lista_compras/features/shopping/cubit/current_shopping_list_cubit.dart';
import 'package:lista_compras/features/shopping/cubit/current_shopping_list_state.dart';
import 'package:lista_compras/features/shopping/domain/entities/create_detail_item_shopping_list_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../bloc/create_detail_item_shoppinglist_bloc.dart';
import '../bloc/create_detail_item_shoppinglist_state.dart';

class CreateDetailItemShoppingListScreen extends StatefulWidget {
  final String itemName;
  final String detailItemId;
  final String listId;
  final String productId;

  const CreateDetailItemShoppingListScreen({
    super.key,
    required this.itemName,
    required this.detailItemId,
    required this.listId,
    required this.productId,
  });

  @override
  State<CreateDetailItemShoppingListScreen> createState() =>
      _CreateDetailItemShoppingListScreenState();
}

class _CreateDetailItemShoppingListScreenState
    extends State<CreateDetailItemShoppingListScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController get _itemNameController =>
      TextEditingController(text: widget.itemName);
  final _itemBrandController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _itemPricePromotionalController = TextEditingController();
  final _itemQuantityController = TextEditingController(text: '1');
  final _itemNotesController = TextEditingController();
  bool get isEditing => widget.detailItemId.isNotEmpty;

  final List<DropdownMenuItem<String>> _typeItems = const [
    DropdownMenuItem(value: 'Unidade', child: Text('Unidade')),
    DropdownMenuItem(value: 'Kg', child: Text('Kg')),
    DropdownMenuItem(value: 'Grama', child: Text('Grama')),
    DropdownMenuItem(value: 'Litro', child: Text('Litro')),
    DropdownMenuItem(value: 'Pacote', child: Text('Pacote')),
  ];

  String? _selectedType;
  bool _isPromotional = false;
  DateTime? _itemDueDate;

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemBrandController.dispose();
    _itemPriceController.dispose();
    _itemPricePromotionalController.dispose();
    _itemQuantityController.dispose();
    _itemNotesController.dispose();
    super.dispose();
  }

  double get _parsedPrice =>
      double.tryParse(_itemPriceController.text.replaceAll(',', '.')) ?? 0;

  double get _parsedPromotionalPrice =>
      double.tryParse(
        _itemPricePromotionalController.text.replaceAll(',', '.'),
      ) ??
      0;

  double get _parsedQuantity =>
      double.tryParse(_itemQuantityController.text.replaceAll(',', '.')) ?? 0;

  double get _totalPrice {
    final unitPrice = _isPromotional ? _parsedPromotionalPrice : _parsedPrice;
    return unitPrice * _parsedQuantity;
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _itemDueDate ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() => _itemDueDate = picked);
    }
  }

  void _saveItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<CreateDetailItemShoppinglistBloc>().add(
      CreateDetailItemRequest(
        CreateDetailItemShoppingListEntity(
          productId: widget.productId,
          listId: widget.listId,
          userId: Supabase.instance.client.auth.currentUser?.id ?? '',
          itemName: _itemNameController.text,
          itemBrand: _itemBrandController.value.text,
          itemPrice: _parsedPrice,
          itemPricePromotional: _parsedPromotionalPrice,
          isPromotional: _isPromotional,
          itemQuantity: _parsedQuantity,
          itemType: _selectedType ?? '',
          itemPriceTotal: _totalPrice,
          itemDueDate: _itemDueDate?.toIso8601String(),
          itemNotes: _itemNotesController.text.isEmpty
              ? null
              : _itemNotesController.text,
        ),
      ),
    );
  }

  Future<void> _addSelectedItems({
    required String listId,
    required String productId,
    required String name,
    required int quantity,
    required String unit,
    required bool checked,
    required int position,
    required double price,
  }) async {
    final categoriesState = context.read<CategoriesItemsBloc>().state;
    if (categoriesState is! CategoriesItemsLoadingSuccess) return;

    context.read<AddItemsInListBloc>().add(
      AddItemsInListRequested(
        listId: listId,
        productId: productId,
        name: 'categoryItem.name',
        quantity: quantity,
        unit: unit,
        checked: false,
        position: position,
        price: price,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Item' : 'Adicionar Item'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child:
            BlocConsumer<
              CreateDetailItemShoppinglistBloc,
              CreateDetailItemShoppinglistState
            >(
              listener: (context, state) {
                if (state is DetailItemShoppingListItemFetchSuccess) {
                  Navigator.pop(context, state.item);
                }
                if (state is DetailItemShoppingListError) {
                  ToastAlert.show(context, state.message);
                }
              },
              builder: (context, state) {
                final isLoading = state is DetailItemShoppingListItemLoading;

                final currentShoppingListState = context
                    .watch<CurrentShoppingListCubit>()
                    .state;

                final currentShoppingList =
                    currentShoppingListState is CurrentShoppingListLoaded
                    ? currentShoppingListState.currentShoppingList
                    : null;

                final shoppingListLocate = currentShoppingList?.local ?? '';

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preencha os dados do item que você quer adicionar à lista.',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),

                        TextFormField(
                          readOnly: true,
                          controller: _itemNameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome do item',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          validator: Validators.required,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _itemBrandController,
                          decoration: const InputDecoration(
                            labelText: 'Marca',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _itemQuantityController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                decoration: const InputDecoration(
                                  labelText: 'Quantidade',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                                validator: Validators.required,
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _selectedType,
                                items: _typeItems,
                                onChanged: (value) =>
                                    setState(() => _selectedType = value),
                                decoration: const InputDecoration(
                                  labelText: 'Tipo',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                                validator: Validators.required,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _itemPriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Preço unitário',
                            prefixText: 'R\$ ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          validator: Validators.required,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 12),

                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Item em promoção'),
                          value: _isPromotional,
                          activeThumbColor: theme.colorScheme.primary,
                          onChanged: (value) =>
                              setState(() => _isPromotional = value),
                        ),

                        if (_isPromotional) ...[
                          TextFormField(
                            controller: _itemPricePromotionalController,
                            autofocus: true,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Preço promocional',
                              prefixText: 'R\$ ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                            ),
                            validator: Validators.required,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 16),
                        ],

                        InkWell(
                          onTap: _pickDueDate,
                          borderRadius: BorderRadius.circular(8),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Validade (opcional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              suffixIcon: Icon(Icons.calendar_today, size: 20),
                            ),
                            child: Text(
                              _itemDueDate == null
                                  ? 'Selecionar data'
                                  : '${_itemDueDate!.day.toString().padLeft(2, '0')}/'
                                        '${_itemDueDate!.month.toString().padLeft(2, '0')}/'
                                        '${_itemDueDate!.year}',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _itemNotesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Observações (opcional)',
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.08,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'R\$ ${_totalPrice.toStringAsFixed(2)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          child: SMButton(
                            text: 'Salvar item',
                            onPressed: () => {
                              if (shoppingListLocate ==
                                  ShoppingListLocateEnum.casa.value)
                                {_saveItem}
                              else
                                {_saveItem, _addSelectedItems},
                            },
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
