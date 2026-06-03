import 'package:flutter/material.dart';
import 'user_navigation_wrapper.dart';
import '../../services_db.dart';

class PantallaMisGalerias extends StatelessWidget {
  const PantallaMisGalerias({super.key});

  void _openImageFullView(BuildContext context, String url, String title) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                url,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 300,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(color: Color(0xFFD97706)),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF475569),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.black,
              ),
              icon: const Icon(Icons.download),
              label: const Text('Descargar en HD', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Descargando archivo digital original...'),
                    backgroundColor: Color(0xFFD97706),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UserNavigationWrapper(
      currentIndex: 2,
      body: StreamBuilder<List<Reservacion>>(
        stream: DatabaseService.instance.streamReservaciones(),
        builder: (context, snapshotRes) {
          final reservaciones = snapshotRes.data ?? [];
          final myResIds = reservaciones
              .where((r) => r.idCliente == AuthService.instance.currentUserId || r.idCliente == AuthService.instance.currentUserName)
              .map((r) => r.idReservacion)
              .toList();

          return StreamBuilder<List<Sesion>>(
            stream: DatabaseService.instance.streamSesiones(),
            builder: (context, snapshotSes) {
              final sesiones = snapshotSes.data ?? [];
              final mySesIds = sesiones
                  .where((s) => myResIds.contains(s.idReservacion))
                  .map((s) => s.idSesion)
                  .toList();

              return StreamBuilder<List<Pedido>>(
                stream: DatabaseService.instance.streamPedidos(),
                builder: (context, snapshotPed) {
                  final pedidos = snapshotPed.data ?? [];
                  final myPedIds = pedidos
                      .where((p) => mySesIds.contains(p.idSesion))
                      .map((p) => p.idPedido)
                      .toList();

                  return StreamBuilder<List<ProductoFinal>>(
                    stream: DatabaseService.instance.streamProductosFinales(),
                    builder: (context, snapshotPF) {
                      final productos = snapshotPF.data ?? [];
                      // Filter final products that are linked to this client's orders
                      final myProducts = productos
                          .where((p) => myPedIds.contains(p.idPedido) || p.idPedido == 'ped1') // ped1 is pre-populated mock forJuan/client1
                          .toList();

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MI GALERÍA DIGITAL',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Accede y descarga las fotos profesionales terminadas de tus sesiones.',
                              style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                            ),
                            const SizedBox(height: 20),

                            Expanded(
                              child: myProducts.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.photo_library_outlined, size: 64, color: const Color(0xFF334155)),
                                          const SizedBox(height: 12),
                                          const Text(
                                            'Tus fotos aparecerán aquí una vez finalizadas por el fotógrafo.',
                                            style: TextStyle(color: Color(0xFF94A3B8)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )
                                  : GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: 0.8,
                                      ),
                                      itemCount: myProducts.length,
                                      itemBuilder: (context, idx) {
                                        final p = myProducts[idx];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF475569),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(color: const Color(0xFF334155), width: 0.5),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () => _openImageFullView(context, p.urlArchivo, '${p.tipo} - ${p.dimensiones}'),
                                                    child: Image.network(
                                                      p.urlArchivo,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (context, child, progress) {
                                                        if (progress == null) return child;
                                                        return Container(
                                                          color: const Color(0xFF334155),
                                                          alignment: Alignment.center,
                                                          child: const CircularProgressIndicator(color: Color(0xFFD97706)),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(12.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        p.tipo,
                                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            p.dimensiones,
                                                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                                                          ),
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                            decoration: BoxDecoration(
                                                              color: Colors.green.withValues(alpha: 0.2),
                                                              borderRadius: BorderRadius.circular(4),
                                                            ),
                                                            child: const Text(
                                                              'HD',
                                                              style: TextStyle(color: Colors.green, fontSize: 8, fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
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
