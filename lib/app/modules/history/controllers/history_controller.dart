import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum TransactionType { contribution, withdrawal, penalty, join, creation }

class HistoryItem {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final TransactionType type;

  HistoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.type,
  });
}

class HistoryController extends GetxController {
  final selectedFilterIndex = 0.obs;
  final List<String> filters = ['Tout', 'Cotisations', 'Gains', 'Pénalités'];
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final _historyItems = <HistoryItem>[].obs;

  Map<String, List<HistoryItem>> get groupedAndFilteredHistory {
    List<HistoryItem> filtered = _getFilteredItems();

    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((item) {
        final query = searchQuery.value.toLowerCase();
        return item.title.toLowerCase().contains(query) ||
            item.subtitle.toLowerCase().contains(query);
      }).toList();
    }
    return groupBy(filtered, (HistoryItem item) {
      final now = DateTime.now();
      final today = DateTime(now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final itemDate = DateTime(item.date.year, item.date.month, item.date.day);

      if (itemDate == today) {
        return 'Aujourd\'hui';
      } else if (itemDate == yesterday) {
        return 'Hier';
      } else {
        return DateFormat.yMMMMd('fr_FR').format(item.date);
      }
    });
  }

  List<HistoryItem> _getFilteredItems() {
    switch (selectedFilterIndex.value) {
      case 1:
        return _historyItems
            .where((item) => item.type == TransactionType.contribution)
            .toList();
      case 2:
        return _historyItems
            .where((item) => item.type == TransactionType.withdrawal)
            .toList();
      case 3:
        return _historyItems
            .where((item) => item.type == TransactionType.penalty)
            .toList();
      case 0:
      default:
        return _historyItems;
    }
  }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
    fetchHistory();
  }

  void changeFilter(int index) {
    selectedFilterIndex.value = index;
  }

  void fetchHistory() {
    // Mock data - replace with API call
    _historyItems.assignAll([
      HistoryItem(
        id: '1',
        title: 'Cotisation Tontine Famille',
        subtitle: 'Tour 5/12',
        amount: -25000,
        date: DateTime.now().subtract(const Duration(hours: 5)),
        type: TransactionType.contribution,
      ),
      HistoryItem(
        id: '2',
        title: 'Gain du tour',
        subtitle: 'Tontine Amis',
        amount: 300000,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.withdrawal,
      ),
      HistoryItem(
        id: '3',
        title: 'Pénalité de retard',
        subtitle: 'Tontine Famille',
        amount: -1000,
        date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        type: TransactionType.penalty,
      ),
      HistoryItem(
        id: '4',
        title: 'Cotisation Tontine Travail',
        subtitle: 'Tour 3/10',
        date: DateTime.now().subtract(const Duration(days: 3)),
        amount: -50000,
        type: TransactionType.contribution,
      ),
      HistoryItem(
        id: '5',
        title: 'Rejoint Tontine Vacances',
        subtitle: 'Frais d\'entrée',
        amount: -5000,
        date: DateTime.now().subtract(const Duration(days: 3, hours: 10)),
        type: TransactionType.join,
      ),
      HistoryItem(
        id: '6',
        title: 'Cotisation Tontine Famille',
        subtitle: 'Tour 4/12',
        amount: -25000,
        date: DateTime.now().subtract(const Duration(days: 32)),
        type: TransactionType.contribution,
      ),
    ]);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
