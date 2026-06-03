import 'package:flutter/material.dart';
import '../../widgets/app_bar_mochi.dart';
import '../../services_db.dart';

class PantallaGestionServicios extends StatefulWidget {
  const PantallaGestionServicios({super.key});

  @override
  State<PantallaGestionServicios> createState() => _PantallaGestionServiciosState();
}

class _PantallaGestionServiciosState extends State<PantallaGestionServicios> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _paqueteFormKey = GlobalKey<FormState>();
  final _estudioFormKey = GlobalKey<FormState>();

  // Paquete Fields
  String _editingPaqueteId = '';
  final _paqNombre = TextEditingController();
  final _paqDescripcion = TextEditingController();
  final _paqFotos = TextEditingController();
  final _paqDuracion = TextEditingController();
  final _paqPrecio = TextEditingController();

  // Estudio Fields
  String _editingEstudioId = '';
  final _estNombre = TextEditingController();
  final _estDescripcion = TextEditingController();
  final _estCapacidad = TextEditingController();
  final _estColorFondo = TextEditingController();
  final _estArea = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _paqNombre.dispose();
    _paqDescripcion.dispose();
    _paqFotos.dispose();
    _paqDuracion.dispose();
    _paqPrecio.dispose();
    
    _estNombre.dispose();
    _estDescripcion.dispose();
    _estCapacidad.dispose();
    _estColorFondo.dispose();
    _estArea.dispose();
    super.dispose();
  }

  void _clearPaqueteFields() {
    _editingPaqueteId = '';
    _paqNombre.clear();
    _paqDescripcion.clear();
    _paqFotos.clear();
    _paqDuracion.clear();
    _paqPrecio.clear();
  }

  void _clearEstudioFields() {
    _editingEstudioId = '';
    _estNombre.clear();
    _estDescripcion.clear();
    _estCapacidad.clear();
    _estColorFondo.clear();
    _estArea.clear();
  }

  // ==========================================
  // SEGMENT 1: PAQUETES CRUD SHEET
  // ==========================================
  void _openPaqueteSheet({Paquete? paquete}) {
    if (paquete != null) {
      _editingPaqueteId = paquete.idPaquete;
      _paqNombre.text = paquete.nombre;
      _paqDescripcion.text = paquete.descripcion;
      _paqFotos.text = paquete.numFotosIncluidas.toString();
      _paqDuracion.text = paquete.duracionMinutos.toString();
      _paqPrecio.text = paquete.precio.toString();
    } else {
      _clearPaqueteFields();
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
              key: _paqueteFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _editingPaqueteId.isEmpty ? 'NUEVO PAQUETE' : 'EDITAR PAQUETE',
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

                  _buildSheetField('Nombre de Paquete:', _paqNombre, 'Sesión Familiar Plata'),
                  _buildSheetField('Descripción:', _paqDescripcion, '1 hora de sesión, 15 imágenes digitales retocadas...'),
                  _buildSheetField('Fotos Incluidas:', _paqFotos, '15', keyboardType: TextInputType.number),
                  _buildSheetField('Duración (Minutos):', _paqDuracion, '60', keyboardType: TextInputType.number),
                  _buildSheetField('Precio (\$):', _paqPrecio, '1200.00', keyboardType: const TextInputType.numberWithOptions(decimal: true)),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      if (!_paqueteFormKey.currentState!.validate()) return;
                      
                      Paquete updated = Paquete(
                        idPaquete: _editingPaqueteId,
                        nombre: _paqNombre.text.trim(),
                        descripcion: _paqDescripcion.text.trim(),
                        numFotosIncluidas: int.tryParse(_paqFotos.text) ?? 0,
                        duracionMinutos: int.tryParse(_paqDuracion.text) ?? 0,
                        precio: double.tryParse(_paqPrecio.text) ?? 0.0,
                      );

                      await DatabaseService.instance.savePaquete(updated);

                      if (context.mounted) {
                        Navigator.pop(context);
                        _clearPaqueteFields();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_editingPaqueteId.isEmpty ? 'Paquete creado con éxito.' : 'Paquete actualizado con éxito.'),
                            backgroundColor: const Color(0xFFD97706),
                          ),
                        );
                      }
                    },
                    child: const Text('GUARDAR PAQUETE', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // SEGMENT 2: ESTUDIOS CRUD SHEET
  // ==========================================
  void _openEstudioSheet({Estudio? estudio}) {
    if (estudio != null) {
      _editingEstudioId = estudio.idEstudio;
      _estNombre.text = estudio.nombre;
      _estDescripcion.text = estudio.descripcion;
      _estCapacidad.text = estudio.capacidadPersonas.toString();
      _estColorFondo.text = estudio.colorFondo;
      _estArea.text = estudio.areaM2.toString();
    } else {
      _clearEstudioFields();
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
              key: _estudioFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _editingEstudioId.isEmpty ? 'NUEVO ESTUDIO' : 'EDITAR ESTUDIO',
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

                  _buildSheetField('Nombre de Estudio:', _estNombre, 'Estudio Luz Natural'),
                  _buildSheetField('Descripción:', _estDescripcion, 'Ventanales amplios orientados al este...'),
                  _buildSheetField('Capacidad de Personas:', _estCapacidad, '5', keyboardType: TextInputType.number),
                  _buildSheetField('Color de Fondos:', _estColorFondo, 'Blanco, Croma Verde, Negro'),
                  _buildSheetField('Área en M2:', _estArea, '45.0', keyboardType: const TextInputType.numberWithOptions(decimal: true)),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      if (!_estudioFormKey.currentState!.validate()) return;
                      
                      Estudio updated = Estudio(
                        idEstudio: _editingEstudioId,
                        nombre: _estNombre.text.trim(),
                        descripcion: _estDescripcion.text.trim(),
                        capacidadPersonas: int.tryParse(_estCapacidad.text) ?? 0,
                        colorFondo: _estColorFondo.text.trim(),
                        areaM2: double.tryParse(_estArea.text) ?? 0.0,
                      );

                      await DatabaseService.instance.saveEstudio(updated);

                      if (context.mounted) {
                        Navigator.pop(context);
                        _clearEstudioFields();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_editingEstudioId.isEmpty ? 'Estudio registrado con éxito.' : 'Estudio actualizado con éxito.'),
                            backgroundColor: const Color(0xFFD97706),
                          ),
                        );
                      }
                    },
                    child: const Text('GUARDAR ESTUDIO', style: TextStyle(fontWeight: FontWeight.bold)),
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
      body: Column(
        children: [
          // Segment selector
          Container(
            color: const Color(0xFF475569),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFFD97706),
              labelColor: const Color(0xFFD97706),
              unselectedLabelColor: const Color(0xFF94A3B8),
              tabs: const [
                Tab(icon: Icon(Icons.shopping_bag_outlined), text: 'PAQUETES'),
                Tab(icon: Icon(Icons.room_outlined), text: 'ESTUDIOS'),
              ],
            ),
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // TAB 1: PAQUETES
                _buildPaquetesTab(),
                // TAB 2: ESTUDIOS
                _buildEstudiosTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaquetesTab() {
    return StreamBuilder<List<Paquete>>(
      stream: DatabaseService.instance.streamPaquetes(),
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
                  const Text('CATÁLOGO DE PAQUETES', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), foregroundColor: Colors.black),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Nuevo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    onPressed: () => _openPaqueteSheet(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: list.isEmpty
                    ? const Center(child: Text('No hay paquetes en catálogo.', style: TextStyle(color: Color(0xFF94A3B8))))
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, idx) {
                          final p = list[idx];
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
                                child: Icon(Icons.card_giftcard, color: Color(0xFFD97706)),
                              ),
                              title: Text(p.nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.descripcion, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${p.numFotosIncluidas} fotos • ${p.duracionMinutos} mins • \$${p.precio.toStringAsFixed(2)}',
                                      style: const TextStyle(color: Color(0xFFD97706), fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(icon: const Icon(Icons.edit, color: Colors.white70, size: 20), onPressed: () => _openPaqueteSheet(paquete: p)),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: const Color(0xFF475569),
                                          title: const Text('Eliminar paquete', style: TextStyle(color: Colors.white)),
                                          content: Text('¿Desea borrar "${p.nombre}" del catálogo?', style: const TextStyle(color: Color(0xFFE2E8F0))),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Color(0xFF94A3B8)))),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                              onPressed: () async {
                                                await DatabaseService.instance.deletePaquete(p.idPaquete);
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paquete eliminado.'), backgroundColor: Colors.redAccent));
                                                }
                                              },
                                              child: const Text('BORRAR', style: TextStyle(fontWeight: FontWeight.bold)),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildEstudiosTab() {
    return StreamBuilder<List<Estudio>>(
      stream: DatabaseService.instance.streamEstudios(),
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
                  const Text('FONDOS Y ESTUDIOS', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), foregroundColor: Colors.black),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Nuevo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    onPressed: () => _openEstudioSheet(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: list.isEmpty
                    ? const Center(child: Text('No hay estudios registrados.', style: TextStyle(color: Color(0xFF94A3B8))))
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, idx) {
                          final e = list[idx];
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
                                child: Icon(Icons.door_sliding_outlined, color: Colors.blueAccent),
                              ),
                              title: Text(e.nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.descripcion, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Capacidad: ${e.capacidadPersonas} personas • Área: ${e.areaM2}m2 • Fondos: ${e.colorFondo}',
                                      style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(icon: const Icon(Icons.edit, color: Colors.white70, size: 20), onPressed: () => _openEstudioSheet(estudio: e)),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: const Color(0xFF475569),
                                          title: const Text('Eliminar estudio', style: TextStyle(color: Colors.white)),
                                          content: Text('¿Desea borrar "${e.nombre}" del registro?', style: const TextStyle(color: Color(0xFFE2E8F0))),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Color(0xFF94A3B8)))),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                              onPressed: () async {
                                                await DatabaseService.instance.deleteEstudio(e.idEstudio);
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Estudio eliminado.'), backgroundColor: Colors.redAccent));
                                                }
                                              },
                                              child: const Text('BORRAR', style: TextStyle(fontWeight: FontWeight.bold)),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}
