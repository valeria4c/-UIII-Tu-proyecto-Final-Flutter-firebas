import 'package:flutter/material.dart';
import '../../widgets/app_bar_mochi.dart';
import '../../services_db.dart';

class PantallaGestionUsuarios extends StatefulWidget {
  const PantallaGestionUsuarios({super.key});

  @override
  State<PantallaGestionUsuarios> createState() => _PantallaGestionUsuariosState();
}

class _PantallaGestionUsuariosState extends State<PantallaGestionUsuarios> {
  final _formKey = GlobalKey<FormState>();
  String _editingId = '';
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _editingId = '';
    _nombreController.clear();
    _apellidoController.clear();
    _emailController.clear();
    _telefonoController.clear();
  }

  void _openAddEditSheet({Cliente? cliente}) {
    if (cliente != null) {
      _editingId = cliente.idCliente;
      _nombreController.text = cliente.nombre;
      _apellidoController.text = cliente.apellido;
      _emailController.text = cliente.email;
      _telefonoController.text = cliente.telefono;
    } else {
      _clearFields();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF475569),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 80,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _editingId.isEmpty ? 'REGISTRAR CLIENTE' : 'EDITAR CLIENTE',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.8),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF334155)),
                  const SizedBox(height: 12),

                  _buildSheetField('Nombre:', _nombreController, 'María'),
                  _buildSheetField('Apellidos:', _apellidoController, 'González'),
                  _buildSheetField('Correo Electrónico:', _emailController, 'maria@correo.com', keyboardType: TextInputType.emailAddress),
                  _buildSheetField('Número Telefónico:', _telefonoController, '555-408-190', keyboardType: TextInputType.phone),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      
                      Cliente updated = Cliente(
                        idCliente: _editingId.isEmpty ? 'cli_${DateTime.now().millisecondsSinceEpoch}' : _editingId,
                        nombre: _nombreController.text.trim(),
                        apellido: _apellidoController.text.trim(),
                        email: _emailController.text.trim(),
                        telefono: _telefonoController.text.trim(),
                        fechaNacimiento: '1995-01-01',
                        fechaRegistro: DateTime.now(),
                      );

                      await DatabaseService.instance.createCliente(updated);

                      if (context.mounted) {
                        Navigator.pop(context);
                        _clearFields();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_editingId.isEmpty ? 'Cliente registrado con éxito.' : 'Cliente actualizado con éxito.'),
                            backgroundColor: const Color(0xFFD97706),
                          ),
                        );
                      }
                    },
                    child: const Text('GUARDAR CLIENTE', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetField(String label, TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF64748B)),
              fillColor: const Color(0xFF334155),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD97706)),
              ),
            ),
            validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF334155),
      appBar: const AppBarMochi(),
      body: StreamBuilder<List<Cliente>>(
        stream: DatabaseService.instance.streamClientes(),
        builder: (context, snapshot) {
          final list = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'GESTIÓN DE CLIENTES',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD97706),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Nuevo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      onPressed: () => _openAddEditSheet(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: list.isEmpty
                      ? const Center(
                          child: Text(
                            'No hay clientes registrados en el sistema.',
                            style: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        )
                      : ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, idx) {
                            final cli = list[idx];
                            return Card(
                              color: const Color(0xFF475569),
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: const Color(0xFF334155), width: 0.5),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: const CircleAvatar(
                                  backgroundColor: Color(0xFF334155),
                                  child: Icon(Icons.person, color: Colors.teal),
                                ),
                                title: Text(
                                  '${cli.nombre} ${cli.apellido}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Correo: ${cli.email}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                      const SizedBox(height: 2),
                                      Text('Teléfono: ${cli.telefono}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                                    ],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                                      onPressed: () => _openAddEditSheet(cliente: cli),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: const Color(0xFF475569),
                                            title: const Text('Eliminar cliente', style: TextStyle(color: Colors.white)),
                                            content: Text('¿Seguro de que quiere borrar la ficha de ${cli.nombre} ${cli.apellido}?', style: const TextStyle(color: Color(0xFFE2E8F0))),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('CANCELAR', style: TextStyle(color: Color(0xFF94A3B8))),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                                onPressed: () async {
                                                  await DatabaseService.instance.deleteCliente(cli.idCliente);
                                                  if (context.mounted) {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Cliente borrado exitosamente.'), backgroundColor: Colors.redAccent),
                                                    );
                                                  }
                                                },
                                                child: const Text('BORRAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
