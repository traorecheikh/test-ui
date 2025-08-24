import 'package:intl/intl.dart';

class Formatters {
  static NumberFormat get _currencyFormatter {
    try {
      return NumberFormat('#,##0', 'fr_FR');
    } catch (e) {
      return NumberFormat('#,##0');
    }
  }

  static DateFormat get _dateFormatter {
    try {
      return DateFormat('dd/MM/yyyy', 'fr_FR');
    } catch (e) {
      return DateFormat('dd/MM/yyyy');
    }
  }

  static DateFormat get _dateTimeFormatter {
    try {
      return DateFormat('dd/MM/yyyy HH:mm', 'fr_FR');
    } catch (e) {
      return DateFormat('dd/MM/yyyy HH:mm');
    }
  }

  static DateFormat get _timeFormatter {
    try {
      return DateFormat('HH:mm', 'fr_FR');
    } catch (e) {
      return DateFormat('HH:mm');
    }
  }

  static String formatCurrency(double amount, {String currency = 'FCFA'}) {
    return '${_currencyFormatter.format(amount)} $currency';
  }

  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return _timeFormatter.format(dateTime);
  }

  static String formatPhoneNumber(String phone) {
    if (phone.length == 9 && phone.startsWith('7')) {
      return '+221 $phone';
    } else if (phone.length == 12 && phone.startsWith('221')) {
      return '+$phone';
    }
    return phone;
  }

  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inHours < 1) {
      return 'Il y a ${difference.inMinutes}min';
    } else if (difference.inDays < 1) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return formatDate(dateTime);
    }
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Asalaam alaikum';
    } else if (hour < 17) {
      return 'Bon après-midi';
    } else {
      return 'Bonsoir';
    }
  }

  static String getContributionStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Payé';
      case 'pending':
        return 'En attente';
      case 'late':
        return 'En retard';
      case 'failed':
        return 'Échec';
      default:
        return status;
    }
  }

  static String formatInviteCode(String code) {
    if (code.length == 6) {
      return '${code.substring(0, 3)}-${code.substring(3)}';
    }
    return code;
  }
}
