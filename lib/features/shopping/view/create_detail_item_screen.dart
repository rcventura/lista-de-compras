import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lista_compras/components/toastAlert/toastAlert.dart';
import 'package:lista_compras/components/SMButtom/SMButtom.dart';
import 'package:lista_compras/core/helpers/currency_input_formatter.dart';
import 'package:lista_compras/core/helpers/enum.dart';
import 'package:lista_compras/core/helpers/validators.dart';
import 'package:lista_compras/features/categories_items/bloc/add_items_in_list_bloc.dart';
import 'package:lista_compras/features/categories_items/bloc/add_items_in_list_event.dart';
import 'package:lista_compras/features/categories_items/bloc/add_items_in_list_state.dart';
import 'package:lista_compras/features/shopping/bloc/create_detail_item_shoppinglist_event.dart';
import 'package:lista_compras/features/shopping/cubit/current_shopping_list_cubit.dart';
import 'package:lista_compras/features/shopping/cubit/current_shopping_list_state.dart';
import 'package:lista_compras/features/shopping/domain/entities/create_detail_item_shopping_list_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../bloc/create_detail_item_shoppinglist_bloc.dart';
import '../bloc/create_detail_item_shoppinglist_state.dart';

class CreateDetailItemShoppingListScreen extends StatefulWidget {
  final String itemName;
  final String listId;
  final String productId;
  final String? listItemId;

  const CreateDetailItemShoppingListScreen({
    super.key,
    required this.itemName,
    required this.listId,
    required this.productId,
    this.listItemId,
  });

  @override
  State<CreateDetailItemShoppingListScreen> createState() =>
      _CreateDetailItemShoppingListScreenState();
}

class _CreateDetailItemShoppingListScreenState
    extends State<CreateDetailItemShoppingListScreen> {
  final _formKey = GlobalKey<FormState>();

  final _createBloc = CreateDetailItemShoppinglistBloc();

  TextEditingController get _itemNameController =>
      TextEditingController(text: widget.itemName);
  final _itemBrandController = TextEditingController();
  var _itemPriceController = TextEditingController();
  final _itemPriceTypeController = TextEditingController();
  final _itemPricePromotionalController = TextEditingController();
  final _itemQuantityController = TextEditingController();
  final _itemNotesController = TextEditingController();
  final _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: '',
    decimalDigits: 2,
  );
  bool get isEditing => widget.listItemId?.isNotEmpty ?? false;

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
  void initState() {
    super.initState();
    if (isEditing) {
     final result =_createBloc.add(
        FetchDetailItemShoppingListRequested(
          widget.listId,
          widget.productId,
          widget.listItemId ?? '',
        ),
      );
    }
  }

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
      double.tryParse(
        _itemPriceController.text
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .replaceAll('R\$', '')
            .trim(),
      ) ??
      0.0;

  double get _parsedPromotionalPrice =>
      double.tryParse(
        _itemPricePromotionalController.text
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .replaceAll('R\$', '')
            .trim(),
      ) ??
      0.0;

  double get _parseFractionalPrice =>
      double.tryParse(
        _itemPriceTypeController.text
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .replaceAll('R\$', '')
            .trim(),
      ) ??
      0.0;

  double get _parsedQuantity =>
      double.tryParse(_itemQuantityController.text.replaceAll(',', '.')) ?? 0.0;

  double get _totalPriceFractional {
    final unitPrice = _parseFractionalPrice * _parsedQuantity;
    return unitPrice;
  }

  double get _totalPrice {
    late final double unitPrice;

    if (!_isPromotional && _itemPriceTypeController.text.isEmpty) {
      unitPrice = _parsedPrice;
    } else if (_isPromotional && _itemPriceTypeController.text.isEmpty) {
      unitPrice = _parsedPromotionalPrice;
    } else if (!_isPromotional && _itemPriceTypeController.text.isNotEmpty) {
      unitPrice = _parseFractionalPrice;
    } else if (_isPromotional && _itemPriceTypeController.text.isNotEmpty) {
      unitPrice = _parsedPromotionalPrice;
    }
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

  Future<String?> _saveItemInList({
    required String listId,
    required String productId,
    required String name,
    required bool checked,
  }) async {
    final bloc = context.read<AddItemsInListBloc>();
    bloc.add(
      AddItemsInListRequested(
        listId: listId,
        productId: productId,
        name: name,
        checked: false,
      ),
    );

    final state = await bloc.stream.firstWhere(
      (s) => s is AddItemsInListSuccess || s is AddItemsInListError,
    );

    if (state is AddItemsInListSuccess) {
      return state.listItemId;
    }

    if (state is AddItemsInListError && mounted) {
      ToastAlert.show(context, state.message);
    }

    return null;
  }

  Future<void> _onSaveItemPressed(String shoppingListLocate) async {
    if (shoppingListLocate == ShoppingListLocateEnum.casa.value) {
      _saveItem(widget.listItemId ?? '');
      return;
    }

    final listItemId = await _saveItemInList(
      checked: false,
      listId: widget.listId,
      productId: widget.productId,
      name: widget.itemName,
    );

    if (listItemId == null) return;

    _saveItem(listItemId);
  }

  void _saveItem(String listItemId) {
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
          listItemId: listItemId,
          itemFractionalPrice: _parseFractionalPrice,
        ),
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
              bloc: _createBloc,
              listener: (context, state) {
                if (state is DetailItemShoppingListItemFetchSuccess) {
                  _selectedType = state.item.itemType;
                  _itemBrandController.text = state.item.itemBrand ?? '';
                  _itemPriceController.text = _formatter.format(
                    state.item.itemPrice,
                  );
                  _isPromotional = state.item.isPromotional;
                  _itemPriceController.text = _formatter.format(
                    state.item.itemPrice,
                  );
                  _itemPricePromotionalController.text = _formatter.format(
                    state.item.itemPricePromotional,
                  );
                  _itemQuantityController.text = state.item.itemQuantity
                      .toString();
                  _itemNotesController.text = state.item.itemNotes ?? '';
                  _itemPriceTypeController.text =
                      state.item.itemFractionalPrice != null
                      ? _formatter.format(state.item.itemFractionalPrice)
                      : '';
                }

                if (state is DetailItemShoppingListError) {
                  ToastAlert.show(context, state.message);
                }

                if (state is DetailItemShoppingListAddSuccess) {
                  ToastAlert.show(context, 'Item adicionado com sucesso!');
                  Navigator.pop(context, true);
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

                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isEditing
                            ? Text(
                                'Atualize os dados do item selecionado.',
                                style: theme.textTheme.bodyMedium,
                              )
                            : Text(
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
                                onChanged: (_) => setState(() {
                                  if (_selectedType != 'Unidade' &&
                                      _selectedType != 'Kg' &&
                                      _selectedType != null) {
                                    _itemPriceController =
                                        TextEditingController(
                                          text: _formatter.format(
                                            _totalPriceFractional,
                                          ),
                                        );
                                  }
                                }),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _selectedType,
                                items: _typeItems,
                                onChanged: (value) => setState(() {
                                  _selectedType = value;
                                  _itemPriceTypeController.clear();
                                  _itemPriceController.clear();
                                }),
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

                        if (_selectedType != 'Unidade' &&
                            _selectedType != 'Kg' &&
                            _selectedType != null) ...[
                          TextFormField(
                            controller: _itemPriceTypeController,
                            inputFormatters: [CurrencyInputFormatter()],
                            autofocus: true,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Preço da $_selectedType',
                              prefixText: 'R\$ ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                            ),
                            validator: Validators.required,
                            onChanged: (_) => setState(() {
                              _itemPriceController = TextEditingController(
                                text: _formatter.format(_totalPriceFractional),
                              );
                            }),
                          ),
                          const SizedBox(height: 16),
                        ],

                        TextFormField(
                          controller: _itemPriceController,

                          inputFormatters: [CurrencyInputFormatter()],
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            enabled:
                                (_selectedType != 'Unidade' &&
                                    _selectedType != 'Kg' &&
                                    _selectedType != null)
                                ? false
                                : true,
                            labelText: 'Preço do item',
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
                          onChanged: (value) {
                            _itemPricePromotionalController.clear();
                            setState(() => _isPromotional = value);
                          },
                        ),

                        if (_isPromotional) ...[
                          TextFormField(
                            controller: _itemPricePromotionalController,
                            inputFormatters: [CurrencyInputFormatter()],
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
                                'R\$ ${_formatter.format(_totalPrice)}',
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
                            text: isEditing ? 'Atualizar' : 'Salvar',
                            onPressed: () =>
                                _onSaveItemPressed(shoppingListLocate),
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
