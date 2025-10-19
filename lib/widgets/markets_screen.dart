import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';

class MarketsScreen extends StatefulWidget {
  const MarketsScreen({Key? key}) : super(key: key);

  @override
  State<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF3B82F6),
          unselectedLabelColor: const Color(0xFF6B7280),
          indicatorColor: const Color(0xFF3B82F6),
          tabs: const [
            Tab(text: 'Crypto'),
            Tab(text: 'FX'),
            Tab(text: 'Indici'),
            Tab(text: 'Azioni'),
            Tab(text: 'Commodities'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMarketList(context.watch<MarketProvider>().cryptoMarkets),
              _buildMarketList(context.watch<MarketProvider>().fxMarkets),
              _buildMarketList(context.watch<MarketProvider>().indicesMarkets),
              _buildMarketList(context.watch<MarketProvider>().cryptoMarkets),
              _buildMarketList(context.watch<MarketProvider>().commoditiesMarkets),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMarketList(List<MarketData> markets) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: markets.length,
      itemBuilder: (context, index) {
        final market = markets[index];
        final isPositive = market.changePercent >= 0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF374151),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          market.symbol,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${market.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFFD1D5DB),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${isPositive ? '+' : ''}${market.changePercent.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: isPositive
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${isPositive ? '+' : ''}${market.change.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: isPositive
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1115),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width *
                            (market.changePercent.abs() / 10),
                        decoration: BoxDecoration(
                          color: isPositive
                              ? const Color(0xFF10B981).withOpacity(0.3)
                              : const Color(0xFFEF4444).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Center(
                        child: Text(
                          market.symbol,
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

