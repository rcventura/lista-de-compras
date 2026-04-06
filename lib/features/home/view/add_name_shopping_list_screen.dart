import 'package:flutter/material.dart';
import '../../../core/helpers/validators.dart';
import '../../../components/toastAlert/toastAlert.dart';

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
      body: Padding(
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
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Nome da lista',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
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
                      labelText: 'Local',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
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
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      validator: Validators.required,
                    ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final nome = _nameTextFieldController.text.trim();
                      if (nome.isNotEmpty) {
                        ToastAlert.show(context, 'Lista "$nome" criada com sucesso!');
                        Duration(seconds: 4);
                        Navigator.pop(context, nome);
                      }
                    }
                  },
                  child: const Text('Criar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
