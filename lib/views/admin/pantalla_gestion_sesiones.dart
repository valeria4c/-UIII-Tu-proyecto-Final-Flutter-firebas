import 'package:flutter/material.dart';
import '../../widgets/app_bar_mochi.dart';
import '../../services_db.dart';

class PantallaGestionSesiones extends StatefulWidget {
  const PantallaGestionSesiones({super.key});

  @override
  State<PantallaGestionSesiones> createState() => _PantallaGestionSesionesState();
}

class _PantallaGestionSesionesState extends State<PantallaGestionSesiones> {
  // Billing and Completion Form Controllers
  final _photoUrlController = TextEditingController();
  final _observacionesController = TextEditingController();
  final String _selectedFormat = 'JPG / RAW';
  bool _isBillingLoading = false;

  @override
  void dispose() {
    _photoUrlController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  void _approveReservation(BuildContext context, Reservacion r) async {
    Reservacion updated = Reservacion(
      idReservacion: r.idReservacion,
      idCliente: r.idCliente,
      idPaquete: r.idPaquete,
      idEstudio: r.idEstudio,
      idFotografo: r.idFotografo,
      fechaHora: r.fechaHora,
      creadaEn: r.creadaEn,
      estado: 'Confirmada',
      canalOrigen: r.canalOrigen,
      notas: r.notas,
    );
    await DatabaseService.instance.saveReservacion(updated);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reservación confirmada con éxito.'), backgroundColor: Colors.blueAccent),
    );
  }

  void _showCompletionSheet(Reservacion r, Paquete p, Estudio e, Fotografo f) {
    // Sample premium photography from Unsplash
    _photoUrlController.text = 'https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=800';
    _observacionesController.text = 'Sesión fotográfica excelente realizada en ${e.nombre} con el fotógrafo ${f.nombre}.';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF475569),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 80, // Added padding for navigation buttons
                top: 24,
                left: 24,
                right: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ENTREGA DE FOTOS',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.0),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF475569)),
                    const SizedBox(height: 12),

                    Text('Paquete: ${p.nombre}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 16),

                    const Text('CARGAR ENTREGABLES DIGITALES', style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.8)),
                    const SizedBox(height: 12),

                    // Photo delivery URL
                    const Text('URL del Archivo Final (Foto):', style: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _photoUrlController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        fillColor: const Color(0xFF334155),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Observaciones
                    const Text('Observaciones de Sesión:', style: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _observacionesController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2,
                      decoration: InputDecoration(
                        fillColor: const Color(0xFF334155),
                        filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Complete Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD97706),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _isBillingLoading
                          ? null
                          : () async {
                              setSheetState(() => _isBillingLoading = true);
                              try {
                                String timeId = DateTime.now().millisecondsSinceEpoch.toString().substring(6);
                                String idSes = 'ses_$timeId';
                                String idProd = 'prod_$timeId';

                                // 1. Create Sesion
                                Sesion s = Sesion(
                                  idSesion: idSes,
                                  idReservacion: r.idReservacion,
                                  fechaHoraInicio: r.fechaHora,
                                  fechaHoraFin: DateTime.now(),
                                  estado: 'Finalizada',
                                  numFotosTomadas: p.numFotosIncluidas + 30,
                                  observaciones: _observacionesController.text.trim(),
                                );
                                await DatabaseService.instance.saveSesion(s);

                                // 2. Create Pedido to link session with the products for the user
                                String idPed = 'ped_$timeId';
                                Pedido ped = Pedido(
                                  idPedido: idPed,
                                  idSesion: idSes,
                                  subtotal: p.precio,
                                  descuento: 0.0,
                                  total: p.precio,
                                  estadoPago: 'Pagado',
                                  fechaPedido: DateTime.now(),
                                );
                                await DatabaseService.instance.savePedido(ped);

                                // 4. Create Producto Final
                                ProductoFinal pf = ProductoFinal(
                                  idProducto: idProd,
                                  idPedido: idPed, // Link to the created Pedido instead of 'ped_NA'
                                  tipo: 'Digital',
                                  formato: _selectedFormat,
                                  dimensiones: '6000 x 4000 px',
                                  cantidad: 1,
                                  precioUnitario: 0.0,
                                  urlArchivo: _photoUrlController.text.trim(),
                                  estadoEntrega: 'Listo',
                                );
                                await DatabaseService.instance.saveProductoFinal(pf);

                                // 5. Update Reservacion
                                Reservacion completedRes = Reservacion(
                                  idReservacion: r.idReservacion,
                                  idCliente: r.idCliente,
                                  idPaquete: r.idPaquete,
                                  idEstudio: r.idEstudio,
                                  idFotografo: r.idFotografo,
                                  fechaHora: r.fechaHora,
                                  creadaEn: r.creadaEn,
                                  estado: 'Completada',
                                  canalOrigen: r.canalOrigen,
                                  notas: r.notas,
                                );
                                await DatabaseService.instance.saveReservacion(completedRes);

                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('¡Fotos cargadas al cliente y sesión completada con éxito!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error al finalizar sesión: $e')),
                                  );
                                }
                              } finally {
                                setSheetState(() => _isBillingLoading = false);
                              }
                            },
                      child: _isBillingLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              'ENTREGAR FOTOS Y FINALIZAR',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF334155),
      appBar: const AppBarMochi(),
      body: StreamBuilder<List<Paquete>>(
        stream: DatabaseService.instance.streamPaquetes(),
        builder: (context, snapPaq) {
          final paquetes = snapPaq.data ?? [];
          return StreamBuilder<List<Estudio>>(
            stream: DatabaseService.instance.streamEstudios(),
            builder: (context, snapEst) {
              final estudios = snapEst.data ?? [];
              return StreamBuilder<List<Fotografo>>(
                stream: DatabaseService.instance.streamFotografos(),
                builder: (context, snapFot) {
                  final fotografos = snapFot.data ?? [];
                  return StreamBuilder<List<Cliente>>(
                    stream: DatabaseService.instance.streamClientes(),
                    builder: (context, snapCli) {
                      final clientes = snapCli.data ?? [];
                      return StreamBuilder<List<Reservacion>>(
                        stream: DatabaseService.instance.streamReservaciones(),
                        builder: (context, snapRes) {
                          final reservaciones = snapRes.data ?? [];

                          // Sort reservations by date
                          reservaciones.sort((a, b) => b.fechaHora.compareTo(a.fechaHora));

                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'AGENDA Y APROBACIÓN DE SESIONES',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Monitorea reservaciones, confirma solicitudes, emite facturas de pedidos y carga entregables.',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                                ),
                                const SizedBox(height: 16),

                                Expanded(
                                  child: reservaciones.isEmpty
                                      ? const Center(child: Text('No hay reservaciones agendadas.', style: TextStyle(color: Color(0xFF94A3B8))))
                                      : ListView.builder(
                                          itemCount: reservaciones.length,
                                          itemBuilder: (context, idx) {
                                            final r = reservaciones[idx];
                                            final p = paquetes.firstWhere((p) => p.idPaquete == r.idPaquete || p.nombre == r.idPaquete, orElse: () => Paquete(idPaquete: '', nombre: r.idPaquete, descripcion: '', numFotosIncluidas: 0, duracionMinutos: 0, precio: 0.0));
                                            final e = estudios.firstWhere((e) => e.idEstudio == r.idEstudio || e.nombre == r.idEstudio, orElse: () => Estudio(idEstudio: '', nombre: r.idEstudio, descripcion: '', capacidadPersonas: 0, colorFondo: '', areaM2: 0));
                                            final f = fotografos.firstWhere((f) => f.idFotografo == r.idFotografo || '${f.nombre} ${f.apellido}' == r.idFotografo, orElse: () => Fotografo(idFotografo: '', nombre: r.idFotografo, apellido: '', email: '', telefono: '', especialidad: '', fechaContrato: ''));
                                            final c = clientes.firstWhere((c) => c.idCliente == r.idCliente || '${c.nombre} ${c.apellido}' == r.idCliente || c.nombre == r.idCliente, orElse: () => Cliente(idCliente: '', nombre: r.idCliente, apellido: '', email: '', telefono: '', fechaNacimiento: '', fechaRegistro: DateTime.now()));

                                            bool isPending = r.estado == 'Pendiente';
                                            bool isConfirmed = r.estado == 'Confirmada';

                                            return Card(
                                              color: const Color(0xFF475569),
                                              margin: const EdgeInsets.only(bottom: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                side: BorderSide(color: const Color(0xFF334155), width: 0.5),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(p.nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                                        _buildStatusChip(r.estado),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text('Cliente: ${c.nombre} ${c.apellido} (${c.telefono})', style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 12)),
                                                    const SizedBox(height: 4),
                                                    Text('Fotógrafo: ${f.nombre} ${f.apellido} | Estudio: ${e.nombre}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                                    const SizedBox(height: 4),
                                                    Text('Fecha/Hora programada: ${r.fechaHora.day}/${r.fechaHora.month}/${r.fechaHora.year} a las ${r.fechaHora.hour.toString().padLeft(2, '0')}:${r.fechaHora.minute.toString().padLeft(2, '0')}', style: const TextStyle(color: Color(0xFFD97706), fontSize: 12, fontWeight: FontWeight.bold)),
                                                    
                                                    if (r.notas.isNotEmpty) ...[
                                                      const SizedBox(height: 8),
                                                      Text('Notas: "${r.notas}"', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontStyle: FontStyle.italic)),
                                                    ],
                                                    
                                                    const SizedBox(height: 12),
                                                    const Divider(color: Color(0xFF334155)),
                                                    const SizedBox(height: 8),
                                                    
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        if (isPending)
                                                          ElevatedButton.icon(
                                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                                                            icon: const Icon(Icons.check, size: 14),
                                                            label: const Text('Confirmar Reserva', style: TextStyle(fontSize: 11)),
                                                            onPressed: () => _approveReservation(context, r),
                                                          ),
                                                        if (isConfirmed)
                                                          ElevatedButton.icon(
                                                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), foregroundColor: Colors.black),
                                                            icon: const Icon(Icons.cloud_upload, size: 14),
                                                            label: const Text('Entregar Fotos y Finalizar', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                                            onPressed: () => _showCompletionSheet(r, p, e, f),
                                                          ),
                                                        if (!isPending && !isConfirmed)
                                                          const Text('No requiere acciones', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                                                      ],
                                                    )
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
}
