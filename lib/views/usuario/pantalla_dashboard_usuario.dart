import 'package:flutter/material.dart';
import 'user_navigation_wrapper.dart';
import '../../services_db.dart';

class PantallaDashboardUsuario extends StatefulWidget {
  const PantallaDashboardUsuario({super.key});

  @override
  State<PantallaDashboardUsuario> createState() => _PantallaDashboardUsuarioState();
}

class _PantallaDashboardUsuarioState extends State<PantallaDashboardUsuario> {
  // Booking Form State
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));
  String? _selectedPaqueteId;
  String? _selectedEstudioId;
  String? _selectedFotografoId;
  final _notasController = TextEditingController();
  bool _isBookingLoading = false;

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  void _showBookingSheet(List<Paquete> paquetes, List<Estudio> estudios, List<Fotografo> fotografos, {String initialCategory = 'Todos'}) {
    if (paquetes.isEmpty || estudios.isEmpty || fotografos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cargando servicios de base de datos...')),
      );
      return;
    }

    String selectedCategory = initialCategory;

    // Helper function to filter packages by category name
    List<Paquete> getFiltered(String cat) {
      List<Paquete> filtered = paquetes.where((p) {
        final nameLower = p.nombre.toLowerCase();
        final descLower = p.descripcion.toLowerCase();
        if (cat == 'Todos') return true;
        if (cat == 'Retratos e Individuales') {
          return !nameLower.contains('boda') && !nameLower.contains('xv') && !nameLower.contains('evento') &&
                 !nameLower.contains('familiar') && !nameLower.contains('familia') &&
                 !nameLower.contains('producto') && !nameLower.contains('comercial') &&
                 !nameLower.contains('croma') && !nameLower.contains('impresion') && !nameLower.contains('edicion');
        }
        if (cat == 'Eventos y Bodas') {
          return nameLower.contains('boda') || nameLower.contains('xv') || nameLower.contains('evento') ||
                 descLower.contains('boda') || descLower.contains('xv') || descLower.contains('evento') || descLower.contains('ceremonia');
        }
        if (cat == 'Producto y Comercial') {
          return nameLower.contains('producto') || nameLower.contains('comercial') || nameLower.contains('catálogo') || nameLower.contains('e-commerce') ||
                 descLower.contains('producto') || descLower.contains('comercial') || descLower.contains('catálogo') || descLower.contains('e-commerce');
        }
        if (cat == 'Fotografía Familiar') {
          return nameLower.contains('familiar') || nameLower.contains('familia') || nameLower.contains('maternidad') || nameLower.contains('bebe') ||
                 descLower.contains('familiar') || descLower.contains('familia') || descLower.contains('maternidad') || descLower.contains('bebe');
        }
        if (cat == 'Sesión de Croma / Efectos') {
          return nameLower.contains('croma') || nameLower.contains('efectos') || nameLower.contains('montaje') || nameLower.contains('pantalla verde') ||
                 descLower.contains('croma') || descLower.contains('efectos') || descLower.contains('montaje') || descLower.contains('pantalla verde');
        }
        if (cat == 'Edición e Impresión') {
          return nameLower.contains('edición') || nameLower.contains('impresión') || nameLower.contains('fotolibro') || nameLower.contains('libro') || nameLower.contains('album') ||
                 descLower.contains('edición') || descLower.contains('impresión') || descLower.contains('fotolibro') || descLower.contains('libro') || descLower.contains('album');
        }
        return true;
      }).toList();
      return filtered.isEmpty ? paquetes : filtered;
    }

    List<Paquete> currentFilteredPaquetes = getFiltered(selectedCategory);
    _selectedPaqueteId = currentFilteredPaquetes.first.nombre;
    _selectedEstudioId ??= estudios.first.nombre;
    _selectedFotografoId ??= '${fotografos.first.nombre} ${fotografos.first.apellido}';

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
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
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
                          'AGENDAR SESIÓN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF8FAFC),
                            letterSpacing: 1.0,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF475569)),
                    const SizedBox(height: 16),

                    // Date Picker
                    const Text('Seleccionar Fecha:', style: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now().add(const Duration(days: 1)),
                          lastDate: DateTime.now().add(const Duration(days: 90)),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: Color(0xFFD97706),
                                  onPrimary: Colors.black,
                                  surface: Color(0xFF475569),
                                  onSurface: Colors.white,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setSheetState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Icon(Icons.calendar_today, color: Color(0xFFD97706), size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Categoría de Servicio Dropdown
                    const Text('Categoría de Servicio:', style: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _buildDropdownContainer(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCategory,
                          dropdownColor: const Color(0xFF1E293B),
                          style: const TextStyle(color: Colors.white),
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'Todos', child: Text('Todos los Servicios')),
                            DropdownMenuItem(value: 'Retratos e Individuales', child: Text('Retratos e Individuales')),
                            DropdownMenuItem(value: 'Eventos y Bodas', child: Text('Eventos y Bodas')),
                            DropdownMenuItem(value: 'Producto y Comercial', child: Text('Producto y Comercial')),
                            DropdownMenuItem(value: 'Fotografía Familiar', child: Text('Fotografía Familiar')),
                            DropdownMenuItem(value: 'Sesión de Croma / Efectos', child: Text('Sesión de Croma / Efectos')),
                            DropdownMenuItem(value: 'Edición e Impresión', child: Text('Edición e Impresión')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setSheetState(() {
                                selectedCategory = val;
                                currentFilteredPaquetes = getFiltered(selectedCategory);
                                _selectedPaqueteId = currentFilteredPaquetes.first.nombre;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Paquete Dropdown
                    const Text('Seleccionar Paquete:', style: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _buildDropdownContainer(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedPaqueteId,
                          dropdownColor: const Color(0xFF1E293B),
                          style: const TextStyle(color: Colors.white),
                          isExpanded: true,
                          items: currentFilteredPaquetes.map((p) {
                            return DropdownMenuItem(
                              value: p.nombre,
                              child: Text('${p.nombre} (\$${p.precio.toStringAsFixed(0)})'),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setSheetState(() => _selectedPaqueteId = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Estudio Dropdown
                    const Text('Seleccionar Estudio/Instalación:', style: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _buildDropdownContainer(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedEstudioId,
                          dropdownColor: const Color(0xFF1E293B),
                          style: const TextStyle(color: Colors.white),
                          isExpanded: true,
                          items: estudios.map((e) {
                            return DropdownMenuItem(
                              value: e.nombre,
                              child: Text('${e.nombre} (${e.colorFondo})'),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setSheetState(() => _selectedEstudioId = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Fotógrafo Dropdown
                    const Text('Seleccionar Fotógrafo:', style: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _buildDropdownContainer(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFotografoId,
                          dropdownColor: const Color(0xFF1E293B),
                          style: const TextStyle(color: Colors.white),
                          isExpanded: true,
                          items: fotografos.map((f) {
                            return DropdownMenuItem(
                              value: '${f.nombre} ${f.apellido}',
                              child: Text('${f.nombre} ${f.apellido} (${f.especialidad})'),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setSheetState(() => _selectedFotografoId = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notas
                    const Text('Notas adicionales:', style: TextStyle(color: Color(0xFFE2E8F0), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notasController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Especificaciones especiales, fondos deseados, poses, etc.',
                        hintStyle: const TextStyle(color: Color(0xFF64748B)),
                        fillColor: const Color(0xFF1E293B),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF334155)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD97706),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _isBookingLoading
                          ? null
                          : () async {
                              setSheetState(() => _isBookingLoading = true);
                              try {
                                Reservacion newRes = Reservacion(
                                  idReservacion: '',
                                  idCliente: AuthService.instance.currentUserId ?? 'guest',
                                  idPaquete: _selectedPaqueteId!,
                                  idEstudio: _selectedEstudioId!,
                                  idFotografo: _selectedFotografoId!,
                                  fechaHora: _selectedDate,
                                  creadaEn: DateTime.now(),
                                  notas: _notasController.text,
                                );
                                await DatabaseService.instance.saveReservacion(newRes);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('¡Reserva agendada exitosamente!'),
                                      backgroundColor: Color(0xFFD97706),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error al reservar: $e')),
                                  );
                                }
                              } finally {
                                setSheetState(() => _isBookingLoading = false);
                              }
                            },
                      child: _isBookingLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              'AGENDAR AHORA',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      _notasController.clear();
    });
  }

  Widget _buildDropdownContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return UserNavigationWrapper(
      currentIndex: 0,
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
                      final myReservations = reservaciones.where((r) => r.idCliente == AuthService.instance.currentUserId || r.idCliente == AuthService.instance.currentUserName).toList();
                      
                      // Sort by date
                      myReservations.sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
                      final nextRes = myReservations.firstWhere((r) => r.fechaHora.isAfter(DateTime.now()), orElse: () => myReservations.isNotEmpty ? myReservations.first : Reservacion(idReservacion: '', idCliente: '', idPaquete: '', idEstudio: '', idFotografo: '', fechaHora: DateTime.now(), creadaEn: DateTime.now()));
                      final hasNext = nextRes.idReservacion.isNotEmpty && nextRes.fechaHora.isAfter(DateTime.now());

                      return ListView(
                        padding: const EdgeInsets.all(20.0),
                        children: [
                          // Welcome Banner
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bienvenido,',
                                    style: TextStyle(fontSize: 14, color: const Color(0xFF94A3B8)),
                                  ),
                                  Text(
                                    AuthService.instance.currentUserName ?? 'Cliente Mochi',
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                              const CircleAvatar(
                                backgroundColor: Color(0xFF475569),
                                radius: 24,
                                child: Icon(Icons.person, color: Color(0xFFD97706)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Next session card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF475569), Color(0xFF334155)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF334155), width: 1.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PRÓXIMA SESIÓN FOTOGRÁFICA',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFD97706), letterSpacing: 1.5),
                                ),
                                const SizedBox(height: 12),
                                if (hasNext) ...[
                                  Text(
                                    paquetes.firstWhere((p) => p.idPaquete == nextRes.idPaquete || p.nombre == nextRes.idPaquete, orElse: () => Paquete(idPaquete: '', nombre: nextRes.idPaquete, descripcion: '', numFotosIncluidas: 0, duracionMinutos: 0, precio: 0.0)).nombre,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 16, color: Color(0xFF94A3B8)),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${nextRes.fechaHora.day}/${nextRes.fechaHora.month}/${nextRes.fechaHora.year} - ${nextRes.fechaHora.hour.toString().padLeft(2, '0')}:${nextRes.fechaHora.minute.toString().padLeft(2, '0')}',
                                        style: const TextStyle(color: Color(0xFFE2E8F0)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.room_outlined, size: 16, color: Color(0xFF94A3B8)),
                                      const SizedBox(width: 8),
                                      Text(
                                        estudios.firstWhere((e) => e.idEstudio == nextRes.idEstudio || e.nombre == nextRes.idEstudio, orElse: () => Estudio(idEstudio: '', nombre: nextRes.idEstudio, descripcion: '', capacidadPersonas: 0, colorFondo: '', areaM2: 0)).nombre,
                                        style: const TextStyle(color: Color(0xFFE2E8F0)),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  const Text(
                                    'NO TIENES NINGUNA SESIÓN ACTIVA',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white70),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Inmortaliza tus mejores momentos hoy mismo con nuestros fotógrafos expertos.',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                                  ),
                                ],
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD97706),
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  onPressed: () => _showBookingSheet(paquetes, estudios, fotografos, initialCategory: 'Todos'),
                                  child: const Text('AGENDAR SESIÓN', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Services header
                          const Text(
                            'NUESTROS SERVICIOS',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFF8FAFC),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Grid
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.5,
                            children: [
                              _buildServiceCard('Retratos e Individuales', Icons.person_pin, 'Paquete Profesional Corporativo o Retrato de Estudio.', paquetes, estudios, fotografos),
                              _buildServiceCard('Eventos y Bodas', Icons.celebration, 'Cobertura integral, foto y video de momentos mágicos.', paquetes, estudios, fotografos),
                              _buildServiceCard('Producto y Comercial', Icons.shopping_bag_outlined, 'Ideal para catálogos digitales e e-commerce premium.', paquetes, estudios, fotografos),
                              _buildServiceCard('Fotografía Familiar', Icons.family_restroom, 'Inmortaliza tus memorias junto a tus seres queridos.', paquetes, estudios, fotografos),
                              _buildServiceCard('Sesión de Croma / Efectos', Icons.video_camera_back, 'Perfecto para montajes y creaciones audaces.', paquetes, estudios, fotografos),
                              _buildServiceCard('Edición e Impresión', Icons.print_outlined, 'Foto libros premium y retoque digital artístico.', paquetes, estudios, fotografos),
                            ],
                          ),
                        ],
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

  Widget _buildServiceCard(String title, IconData icon, String subtitle, List<Paquete> pq, List<Estudio> es, List<Fotografo> ft) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF475569),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Interactive Bottom Sheet explaining the service
            showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFF475569),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(icon, color: const Color(0xFFD97706), size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        subtitle,
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Todos nuestros servicios son realizados con equipos de última generación (Sony A7IV) e iluminación profesional.',
                        style: TextStyle(color: Colors.white70, fontSize: 13, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), foregroundColor: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                          _showBookingSheet(pq, es, ft, initialCategory: title);
                        },
                        child: const Text('RESERVAR ESTE SERVICIO', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: const Color(0xFFD97706), size: 24),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
