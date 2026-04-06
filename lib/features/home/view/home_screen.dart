import 'package:flutter/material.dart';
import 'package:lista_compras/features/home/view/add_name_shopping_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _listas = [];

  Future<void> _navigateToAddList() async {
    final novaLista = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const AddNameShoppingListScreen()),
    );

    if (novaLista != null && novaLista.isNotEmpty) {
      setState(() => _listas.add(novaLista));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Colors.black54),
          onPressed: _navigateToAddList,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black54),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 80,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'Rodrigo Ventura',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.email_outlined, size: 16),
                              SizedBox(width: 6),
                              Text('rodrigo.ventura@example.com'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(color: Colors.grey[300]),
                          TextButton(
                            onPressed: () {
                              // Lógica para logout
                            },
                            child: const Text(
                              'Sair',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 30,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: const Text(
                'Minhas Listas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ),

            Expanded(
              child: _listas.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_cart_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Nenhuma lista criada ainda.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Toque no + para criar sua primeira lista.',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _listas.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_listas[index]),
                          subtitle: const Text('3 itens'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Lógica para abrir detalhes da lista
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
