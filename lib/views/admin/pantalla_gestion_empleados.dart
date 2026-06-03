import 'package:flutter/material.dart';
import '../../widgets/app_bar_mochi.dart';
import '../../services_db.dart';

class PantallaGestionEmpleados extends StatefulWidget {
  const PantallaGestionEmpleados({super.key});

  @override
  State<PantallaGestionEmpleados> createState() => _PantallaGestionEmpleadosState();
}

class _PantallaGestionEmpleadosState extends State<PantallaGestionEmpleados> {
  final _formKey = GlobalKey<FormState>();
  String _editingId = '';
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _especialidadController = TextEditingController();
  final _fechaContratoController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _especialidadController.dispose();
    _fechaContratoController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _editingId = '';
    _nombreController.clear();
    _apellidoController.clear();
    _emailController.clear();
    _telefonoController.clear();
    _especialidadController.clear();
    _fechaContratoController.clear();
  }

  void _openAddEditSheet({Fotografo? fotografo}) {
    if (fotografo != null) {
      _editingId = fotografo.idFotografo;
      _nombreController.text = fotografo.nombre;
      _apellidoController.text = fotografo.apellido;
      _emailController.text = fotografo.email;
      _telefonoController.text = fotografo.telefono;
      _especialidadController.text = fotografo.especialidad;
      _fechaContratoController.text = fotografo.fechaContrato;
    } else {
      _clearFields();
      _fechaContratoController.text = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
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
                        _editingId.isEmpty ? 'NUEVO FOTÓGRAFO' : 'EDITAR FOTÓGRAFO',
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

                  _buildSheetField('Nombre:', _nombreController, 'Juan'),
                  _buildSheetField('Apellido:', _apellidoController, 'Gómez'),
                  _buildSheetField('Correo electrónico:', _emailController, 'juan.gomez@mochi.com', keyboardType: TextInputType.emailAddress),
                  _buildSheetField('Teléfono:', _telefonoController, '555-9080-12', keyboardType: TextInputType.phone),
                  _buildSheetField('Especialidad:', _especialidadController, 'Retrato, Producto, Bodas'),
                  _buildSheetField('Fecha Contrato (YYYY-MM-DD):', _fechaContratoController, '2024-05-20'),

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
                      
                      Fotografo updated = Fotografo(
                        idFotografo: _editingId,
                        nombre: _nombreController.text.trim(),
                        apellido: _apellidoController.text.trim(),
                        email: _emailController.text.trim(),
                        telefono: _telefonoController.text.trim(),
                        especialidad: _especialidadController.text.trim(),
                        fechaContrato: _fechaContratoController.text.trim(),
                      );

                      await DatabaseService.instance.saveFotografo(updated);

                      if (context.mounted) {
                        Navigator.pop(context);
                        _clearFields();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_editingId.isEmpty ? 'Fotógrafo registrado con éxito.' : 'Datos actualizados con éxito.'),
                            backgroundColor: const Color(0xFFD97706),
                          ),
                        );
                      }
                    },
                    child: const Text('GUARDAR FOTÓGRAFO', style: TextStyle(fontWeight: FontWeight.bold)),
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
      body: StreamBuilder<List<Fotografo>>(
        stream: DatabaseService.instance.streamFotografos(),
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
                      'GESTIÓN DE FOTÓGRAFOS',
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
                            'No hay fotógrafos registrados.',
                            style: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        )
                      : ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, idx) {
                            final fot = list[idx];
                            return Card(
                              color: const Color(0xFF475569),
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: const Color(0xFF334155), width: 0.5),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                leading: const CircleAvatar(
                                  backgroundColor: Color(0xFF334155),
                                  child: Icon(Icons.camera_alt, color: Color(0xFFD97706)),
                                ),
                                title: Text(
                                  '${fot.nombre} ${fot.apellido}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Especialidad: ${fot.especialidad}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                      const SizedBox(height: 2),
                                      Text('Contacto: ${fot.telefono} | ${fot.email}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                                    ],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                                      onPressed: () => _openAddEditSheet(fotografo: fot),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                      onPressed: () {
                                        // Dynamic confirm deletion alert
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: const Color(0xFF475569),
                                            title: const Text('Eliminar fotógrafo', style: TextStyle(color: Colors.white)),
                                            content: Text('¿Seguro de que quiere eliminar a ${fot.nombre} ${fot.apellido} de la plantilla?', style: const TextStyle(color: Color(0xFFE2E8F0))),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('CANCELAR', style: TextStyle(color: Color(0xFF94A3B8))),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                                onPressed: () async {
                                                  await DatabaseService.instance.deleteFotografo(fot.idFotografo);
                                                  if (context.mounted) {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Fotógrafo removido con éxito.'), backgroundColor: Colors.redAccent),
                                                    );
                                                  }
                                                },
                                                child: const Text('SÍ, BORRAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
