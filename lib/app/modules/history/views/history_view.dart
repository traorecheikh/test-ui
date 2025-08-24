import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Historique',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(theme),
          Expanded(child: _buildHistoryList(theme)),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          CupertinoSearchTextField(
            controller: controller.searchController,
            placeholder: 'Rechercher une transaction...',
            backgroundColor: theme.colorScheme.surface,
            style: theme.textTheme.bodyLarge,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.filters.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  final isSelected =
                      controller.selectedFilterIndex.value == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(controller.filters[index]),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          controller.changeFilter(index);
                        }
                      },
                      backgroundColor: theme.colorScheme.surface,
                      selectedColor: theme.colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide.none,
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(ThemeData theme) {
    return Obx(() {
      final groupedItems = controller.groupedAndFilteredHistory;
      if (groupedItems.isEmpty) {
        return _buildEmptyState(theme);
      }
      final dates = groupedItems.keys.toList();
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: dates.length,
        itemBuilder: (context, dateIndex) {
          final date = dates[dateIndex];
          final items = groupedItems[date]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 12, top: 20),
                child: Text(
                  date.toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              ...items.map((item) => _HistoryItemCard(item: item)).toList(),
            ],
          );
        },
      );
    });
  }

  Widget _buildEmptyState(ThemeData theme) {
    final isSearching = controller.searchQuery.value.isNotEmpty;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? CupertinoIcons.search : CupertinoIcons.clock_fill,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            isSearching
                ? 'Aucun résultat trouvé'
                : 'Aucune transaction pour l\'instant',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              isSearching
                  ? 'Essayez de rechercher avec d\'autres mots-clés.'
                  : 'Vos transactions et activités apparaîtront ici.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItemCard extends StatelessWidget {
  final HistoryItem item;

  const _HistoryItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCredit = item.amount > 0;
    final format = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildIcon(theme),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  item.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${isCredit ? '+' : ''}${format.format(item.amount).replaceAll(',00', '')}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isCredit ? Colors.green.shade600 : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    final Map<TransactionType, dynamic> typeMap = {
      TransactionType.contribution: {
        'icon': CupertinoIcons.arrow_up,
        'color': Colors.blue,
      },
      TransactionType.withdrawal: {
        'icon': CupertinoIcons.arrow_down,
        'color': Colors.green,
      },
      TransactionType.penalty: {
        'icon': CupertinoIcons.exclamationmark_triangle,
        'color': Colors.red,
      },
      TransactionType.join: {
        'icon': CupertinoIcons.person_add,
        'color': Colors.purple,
      },
      TransactionType.creation: {
        'icon': CupertinoIcons.star_fill,
        'color': Colors.orange,
      },
    };

    final type = typeMap[item.type]!;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: (type['color'] as Color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        type['icon'] as IconData,
        color: type['color'] as Color,
        size: 24,
      ),
    );
  }
}
