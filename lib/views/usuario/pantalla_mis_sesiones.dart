import 'package:flutter/material.dart';
import 'user_navigation_wrapper.dart';
import 'pantalla_pago_reserva.dart';
import '../../services_db.dart';

class PantallaMisSesiones extends StatefulWidget {
  const PantallaMisSesiones({super.key});

  @override
  State<PantallaMisSesiones> createState() => _PantallaMisSesionesState();
}

class _PantallaMisSesionesState extends State<PantallaMisSesiones> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSessionDetails(Reservacion r, Paquete p, Estudio e, Fotografo f) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF475569),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        bool canCancel = r.estado != 'Cancelada' && r.estado != 'Completada';

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    p.nombre,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  _buildStatusChip(r.estado),
                ],
              ),
              const Divider(color: Color(0xFF475569)),
              const SizedBox(height: 12),

              _buildDetailItem(Icons.calendar_month, 'Fecha y Hora', '${r.fechaHora.day}/${r.fechaHora.month}/${r.fechaHora.year} a las ${r.fechaHora.hour.toString().padLeft(2, '0')}:${r.fechaHora.minute.toString().padLeft(2, '0')}'),
              _buildDetailItem(Icons.camera_alt, 'Fotógrafo Asignado', '${f.nombre} ${f.apellido} (${f.especialidad})'),
              _buildDetailItem(Icons.room, 'Estudio Reservado', '${e.nombre} - Fondo: ${e.colorFondo}'),
              _buildDetailItem(Icons.attach_money, 'Precio de Sesión', '\$${p.precio.toStringAsFixed(2)}'),
              if (r.notas.isNotEmpty)
                _buildDetailItem(Icons.notes, 'Notas de Reserva', r.notas),

              const SizedBox(height: 24),

              if (r.estado == 'Pendiente')
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      Navigator.pop(context); // Close the bottom sheet
                      bool? success = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PantallaPagoReserva(reservacion: r, paquete: p),
                        ),
                      );
                      if (success == true && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Proceso de pago completado con éxito.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    child: const Text('PAGAR SESIÓN', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),

              if (canCancel)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    // Update reservation status to "Cancelada"
                    Reservacion updated = Reservacion(
                      idReservacion: r.idReservacion,
                      idCliente: r.idCliente,
                      idPaquete: r.idPaquete,
                      idEstudio: r.idEstudio,
                      idFotografo: r.idFotografo,
                      fechaHora: r.fechaHora,
                      creadaEn: r.creadaEn,
                      estado: 'Cancelada',
                      canalOrigen: r.canalOrigen,
                      notas: r.notas,
                    );
                    await DatabaseService.instance.saveReservacion(updated);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sesión cancelada con éxito.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: const Text('CANCELAR SESIÓN', style: TextStyle(fontWeight: FontWeight.bold)),
                )
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF334155),
                    foregroundColor: Colors.white70,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CERRAR DETALLES'),
                ),
            ],
          ),
         ),
        );
      },
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFD97706), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFFE2E8F0))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String estado) {
    Color bg;
    Color fg;
    if (estado == 'Completada') {
      bg = Colors.green.withValues(alpha: 0.2);
      fg = Colors.green;
    } else if (estado == 'Confirmada') {
      bg = Colors.blue.withValues(alpha: 0.2);
      fg = Colors.blue;
    } else if (estado == 'Cancelada') {
      bg = Colors.redAccent.withValues(alpha: 0.2);
      fg = Colors.redAccent;
    } else {
      bg = const Color(0xFFD97706).withValues(alpha: 0.2);
      fg = const Color(0xFFD97706);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg, width: 0.5),
      ),
      child: Text(
        estado.toUpperCase(),
        style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UserNavigationWrapper(
      currentIndex: 1,
      body: StreamBuilder<List<Paquete>>(
        stream: DatabaseService.instance.streamPaquetes(),
        builder: (context, snapshotPaq) {
          final paquetes = snapshotPaq.data ?? [];
          return StreamBuilder<List<Estudio>>(
            stream: DatabaseService.instance.streamEstudios(),
            builder: (context, snapshotEst) {
              final estudios = snapshotEst.data ?? [];
              return StreamBuilder<List<Fotografo>>(
                stream: DatabaseService.instance.streamFotografos(),
                builder: (context, snapshotFot) {
                  final fotografos = snapshotFot.data ?? [];
                  return StreamBuilder<List<Reservacion>>(
                    stream: DatabaseService.instance.streamReservaciones(),
                    builder: (context, snapshotRes) {
                      final reservaciones = snapshotRes.data ?? [];
                      
                      // Filter by current client
                          final myReservations = reservaciones
                              .where((r) => r.idCliente == AuthService.instance.currentUserId || r.idCliente == AuthService.instance.currentUserName)
                              .toList();

                      // Apply search filter
                      final filtered = myReservations.where((r) {
                        final p = paquetes.firstWhere((p) => p.idPaquete == r.idPaquete || p.nombre == r.idPaquete, orElse: () => Paquete(idPaquete: '', nombre: r.idPaquete, descripcion: '', numFotosIncluidas: 0, duracionMinutos: 0, precio: 0.0));
                        final f = fotografos.firstWhere((f) => f.idFotografo == r.idFotografo || '${f.nombre} ${f.apellido}' == r.idFotografo, orElse: () => Fotografo(idFotografo: '', nombre: r.idFotografo, apellido: '', email: '', telefono: '', especialidad: '', fechaContrato: ''));
                        
                        final query = _searchQuery.toLowerCase();
                        return p.nombre.toLowerCase().contains(query) ||
                            r.estado.toLowerCase().contains(query) ||
                            '${f.nombre} ${f.apellido}'.toLowerCase().contains(query);
                      }).toList();

                      // Sort by date (descending)
                      filtered.sort((a, b) => b.fechaHora.compareTo(a.fechaHora));

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MIS SESIONES FOTOGRÁFICAS',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 12),
                            
                            // Elegant search bar
                            TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Buscar por paquete, fotógrafo o estado...',
                                hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                                prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                                fillColor: const Color(0xFF475569),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF334155)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFD97706)),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _searchQuery = val;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            // List
                            Expanded(
                              child: filtered.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.collections_bookmark_outlined, size: 64, color: const Color(0xFF334155)),
                                          const SizedBox(height: 12),
                                          Text(
                                            _searchQuery.isEmpty 
                                                ? 'Aún no has reservado ninguna sesión.' 
                                                : 'No se encontraron sesiones para tu búsqueda.',
                                            style: const TextStyle(color: Color(0xFF94A3B8)),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: filtered.length,
                                      itemBuilder: (context, idx) {
                                        final r = filtered[idx];
                                        final p = paquetes.firstWhere((p) => p.idPaquete == r.idPaquete || p.nombre == r.idPaquete, orElse: () => Paquete(idPaquete: '', nombre: r.idPaquete, descripcion: '', numFotosIncluidas: 0, duracionMinutos: 0, precio: 0.0));
                                        final e = estudios.firstWhere((e) => e.idEstudio == r.idEstudio || e.nombre == r.idEstudio, orElse: () => Estudio(idEstudio: '', nombre: r.idEstudio, descripcion: '', capacidadPersonas: 0, colorFondo: '', areaM2: 0));
                                        final f = fotografos.firstWhere((f) => f.idFotografo == r.idFotografo || '${f.nombre} ${f.apellido}' == r.idFotografo, orElse: () => Fotografo(idFotografo: '', nombre: r.idFotografo, apellido: '', email: '', telefono: '', especialidad: '', fechaContrato: ''));

                                        return Card(
                                          color: const Color(0xFF475569),
                                          margin: const EdgeInsets.only(bottom: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            side: BorderSide(color: const Color(0xFF334155), width: 0.5),
                                          ),
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.all(16),
                                            leading: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF334155),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Icon(Icons.photo_library, color: Color(0xFFD97706), size: 24),
                                            ),
                                            title: Text(
                                              p.nombre,
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(top: 6.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${r.fechaHora.day}/${r.fechaHora.month}/${r.fechaHora.year} - ${r.fechaHora.hour.toString().padLeft(2, '0')}:${r.fechaHora.minute.toString().padLeft(2, '0')}',
                                                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  _buildStatusChip(r.estado),
                                                ],
                                              ),
                                            ),
                                            trailing: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF334155),
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                minimumSize: const Size(60, 36),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              ),
                                              onPressed: () => _showSessionDetails(r, p, e, f),
                                              child: const Text('Ver Detalles', style: TextStyle(fontSize: 11)),
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
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
