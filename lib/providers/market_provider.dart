import 'package:flutter/material.dart';

class MarketData {
  final String symbol;
  final double price;
  final double change;
  final double changePercent;
  final String assetClass;

  MarketData({
    required this.symbol,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.assetClass,
  });
}

class MarketProvider extends ChangeNotifier {
  List<MarketData> _cryptoMarkets = [];
  List<MarketData> _fxMarkets = [];
  List<MarketData> _indicesMarkets = [];
  List<MarketData> _commoditiesMarkets = [];

  List<MarketData> get cryptoMarkets => _cryptoMarkets;
  List<MarketData> get fxMarkets => _fxMarkets;
  List<MarketData> get indicesMarkets => _indicesMarkets;
  List<MarketData> get commoditiesMarkets => _commoditiesMarkets;

  MarketProvider() {
    _initializeMockData();
  }

  void _initializeMockData() {
    _cryptoMarkets = [
      MarketData(
        symbol: 'BTC/USDT',
        price: 63250.50,
        change: 1250.50,
        changePercent: 2.02,
        assetClass: 'Crypto',
      ),
      MarketData(
        symbol: 'ETH/USDT',
        price: 2450.75,
        change: -85.25,
        changePercent: -3.37,
        assetClass: 'Crypto',
      ),
      MarketData(
        symbol: 'SOL/USDT',
        price: 145.30,
        change: 8.50,
        changePercent: 6.22,
        assetClass: 'Crypto',
      ),
      MarketData(
        symbol: 'XRP/USDT',
        price: 2.85,
        change: 0.15,
        changePercent: 5.56,
        assetClass: 'Crypto',
      ),
      MarketData(
        symbol: 'ADA/USDT',
        price: 1.12,
        change: -0.08,
        changePercent: -6.67,
        assetClass: 'Crypto',
      ),
    ];

    _fxMarkets = [
      MarketData(
        symbol: 'EUR/USD',
        price: 1.0850,
        change: 0.0025,
        changePercent: 0.23,
        assetClass: 'FX',
      ),
      MarketData(
        symbol: 'GBP/USD',
        price: 1.2680,
        change: -0.0050,
        changePercent: -0.39,
        assetClass: 'FX',
      ),
      MarketData(
        symbol: 'USD/JPY',
        price: 149.50,
        change: 1.25,
        changePercent: 0.84,
        assetClass: 'FX',
      ),
      MarketData(
        symbol: 'AUD/USD',
        price: 0.6580,
        change: 0.0015,
        changePercent: 0.23,
        assetClass: 'FX',
      ),
      MarketData(
        symbol: 'USD/CAD',
        price: 1.3650,
        change: -0.0025,
        changePercent: -0.18,
        assetClass: 'FX',
      ),
    ];

    _indicesMarkets = [
      MarketData(
        symbol: 'SPX',
        price: 5890.50,
        change: 125.50,
        changePercent: 2.18,
        assetClass: 'Indices',
      ),
      MarketData(
        symbol: 'NDX',
        price: 20150.75,
        change: 450.75,
        changePercent: 2.28,
        assetClass: 'Indices',
      ),
      MarketData(
        symbol: 'DXY',
        price: 104.25,
        change: -0.50,
        changePercent: -0.48,
        assetClass: 'Indices',
      ),
      MarketData(
        symbol: 'VIX',
        price: 14.50,
        change: -1.25,
        changePercent: -7.94,
        assetClass: 'Indices',
      ),
      MarketData(
        symbol: 'FTSE',
        price: 8150.25,
        change: 85.25,
        changePercent: 1.06,
        assetClass: 'Indices',
      ),
    ];

    _commoditiesMarkets = [
      MarketData(
        symbol: 'GOLD',
        price: 2085.50,
        change: 25.50,
        changePercent: 1.24,
        assetClass: 'Commodities',
      ),
      MarketData(
        symbol: 'OIL (WTI)',
        price: 78.45,
        change: -1.55,
        changePercent: -1.94,
        assetClass: 'Commodities',
      ),
      MarketData(
        symbol: 'NATURAL GAS',
        price: 2.85,
        change: 0.15,
        changePercent: 5.56,
        assetClass: 'Commodities',
      ),
      MarketData(
        symbol: 'COPPER',
        price: 4.25,
        change: 0.08,
        changePercent: 1.92,
        assetClass: 'Commodities',
      ),
      MarketData(
        symbol: 'CORN',
        price: 425.50,
        change: -8.50,
        changePercent: -1.96,
        assetClass: 'Commodities',
      ),
    ];
  }

  void refreshMarkets() {
    // Simula aggiornamento dati
    notifyListeners();
  }
}

