import 'package:flutter/material.dart';
import '../../services_db.dart';
import '../../widgets/app_bar_mochi.dart';

class PantallaPagoReserva extends StatefulWidget {
  final Reservacion reservacion;
  final Paquete paquete;

  const PantallaPagoReserva({
    super.key,
    required this.reservacion,
    required this.paquete,
  });

  @override
  State<PantallaPagoReserva> createState() => _PantallaPagoReservaState();
}

class _PantallaPagoReservaState extends State<PantallaPagoReserva> {
  String _metodoSeleccionado = 'Tarjeta';
  bool _isLoading = false;

  final _formKeyTarjeta = GlobalKey<FormState>();
  final _formKeyPaypal = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF334155),
      appBar: const AppBarMochi(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 20),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                const Text(
                  'PAGO DE RESERVA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF475569),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD97706), width: 1.5),
              ),
              child: Column(
                children: [
                  Text(
                    'Total a pagar por: ${widget.paquete.nombre}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.paquete.precio.toStringAsFixed(2)} MXN',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Selecciona un método de pago',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMetodoSelector(),
            const SizedBox(height: 24),
            _buildFormularioDinamico(),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isLoading ? null : _procesarPago,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                    )
                  : Text(
                      _metodoSeleccionado == 'Efectivo' ? 'CONFIRMAR RESERVA FÍSICA' : 'PAGAR AHORA',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetodoSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMetodoOption('Tarjeta', Icons.credit_card),
        _buildMetodoOption('PayPal', Icons.paypal),
        _buildMetodoOption('Efectivo', Icons.money),
      ],
    );
  }

  Widget _buildMetodoOption(String title, IconData icon) {
    bool isSelected = _metodoSeleccionado == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _metodoSeleccionado = title;
        });
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD97706).withValues(alpha: 0.1) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFD97706) : const Color(0xFF334155),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFFD97706) : const Color(0xFF94A3B8), size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFFD97706) : const Color(0xFF94A3B8),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormularioDinamico() {
    if (_metodoSeleccionado == 'Tarjeta') {
      return Form(
        key: _formKeyTarjeta,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detalles de Tarjeta', style: TextStyle(color: Color(0xFF94A3B8))),
            const SizedBox(height: 12),
            _buildTextField(label: 'Número de Tarjeta', hint: '0000 0000 0000 0000', icon: Icons.credit_card, isNumber: true),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField(label: 'Vencimiento', hint: 'MM/AA', icon: Icons.calendar_month, isNumber: true)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(label: 'CVV', hint: '123', icon: Icons.lock_outline, isNumber: true, obscureText: true)),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(label: 'Nombre del Titular', hint: 'Como aparece en la tarjeta', icon: Icons.person_outline),
          ],
        ),
      );
    } else if (_metodoSeleccionado == 'PayPal') {
      return Form(
        key: _formKeyPaypal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cuenta de PayPal', style: TextStyle(color: Color(0xFF94A3B8))),
            const SizedBox(height: 12),
            _buildTextField(label: 'Correo Electrónico', hint: 'ejemplo@paypal.com', icon: Icons.email_outlined),
          ],
        ),
      );
    } else {
      // Efectivo / Físico
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFFD97706), size: 40),
            const SizedBox(height: 16),
            const Text(
              'Pago en Sucursal',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tienes 2 días de tolerancia para realizar tu pago físicamente en el estudio. De lo contrario, tu reservación se anulará automáticamente para liberar el espacio.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF94A3B8), height: 1.5, fontSize: 13),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTextField({required String label, required String hint, required IconData icon, bool isNumber = false, bool obscureText = false}) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      validator: (val) {
        if (val == null || val.isEmpty) return 'Campo requerido';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF64748B)),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF475569)),
        prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
        fillColor: const Color(0xFF1E293B),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD97706)),
        ),
      ),
    );
  }

  Future<void> _procesarPago() async {
    // Validar formularios si es digital
    if (_metodoSeleccionado == 'Tarjeta' && !_formKeyTarjeta.currentState!.validate()) {
      return;
    }
    if (_metodoSeleccionado == 'PayPal' && !_formKeyPaypal.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // Simular un retraso de procesamiento
    await Future.delayed(const Duration(seconds: 2));

    // Crear un mock de pago y actualizar la reservación
    String nuevoEstado = _metodoSeleccionado == 'Efectivo' ? 'Pendiente' : 'Confirmada';
    String notaPago = _metodoSeleccionado == 'Efectivo' 
        ? 'Pago en sucursal pendiente (Regla de 2 días de tolerancia aplicable).' 
        : 'Pagado en línea vía $_metodoSeleccionado.';

    // Actualizamos la reserva
    Reservacion updated = Reservacion(
      idReservacion: widget.reservacion.idReservacion,
      idCliente: widget.reservacion.idCliente,
      idPaquete: widget.reservacion.idPaquete,
      idEstudio: widget.reservacion.idEstudio,
      idFotografo: widget.reservacion.idFotografo,
      fechaHora: widget.reservacion.fechaHora,
      estado: nuevoEstado,
      canalOrigen: widget.reservacion.canalOrigen,
      notas: '${widget.reservacion.notas}\n\n[SISTEMA]: $notaPago'.trim(),
      creadaEn: widget.reservacion.creadaEn,
    );

    await DatabaseService.instance.saveReservacion(updated);

    if (!mounted) return;
    Navigator.pop(context, true); // Devuelve true si fue exitoso
  }
}
