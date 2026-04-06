import 'package:flutter/material.dart';
import '../../../core/helpers/validators.dart';

class AddNameShoppingListScreen extends StatefulWidget {
  const AddNameShoppingListScreen({super.key});

  @override
  State<AddNameShoppingListScreen> createState() =>
      _AddNameShoppingListScreenState();
}

class _AddNameShoppingListScreenState extends State<AddNameShoppingListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  List<DropdownMenuItem<String>> items = [
    const DropdownMenuItem(value: 'Casa', child: Text('Casa')),
    const DropdownMenuItem(value: 'Mercado', child: Text('Mercado')),
  ];
  String? _selectedValue;

  @override
  void dispose() {
    _controller.dispose();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Adicione o nome e o local que esta criando esta lista.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Nome da lista',
                    ),
                    validator: Validators.required,
                  ),
                  const SizedBox(height: 30),
                  DropdownButton(
                    items: items,
                    value: _selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedValue = value;
                      });
                      print('Valor selecionado: $value');
                    },
                  )
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final nome = _controller.text.trim();
                      if (nome.isNotEmpty) {
                        Navigator.pop(context, nome);
                      }
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
