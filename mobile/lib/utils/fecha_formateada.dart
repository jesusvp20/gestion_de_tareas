import 'package:intl/intl.dart';

class FormatearFecha {
  /// Formatea una fecha a un string con el formato 'dd/MM/yyyy hh:mm a'
  static String formatearFecha(DateTime? fecha) {
    if (fecha == null) return '';
    return DateFormat('dd/MM/yyyy hh:mm a').format(fecha);
  }
}