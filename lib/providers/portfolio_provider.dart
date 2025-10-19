import 'package:flutter/material.dart';

class Position {
  final String symbol;
  final String side;
  final double quantity;
  final double entryPrice;
  final double currentPrice;
  final DateTime openedAt;

  Position({
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.entryPrice,
    required this.currentPrice,
    required this.openedAt,
  });

  double get pnl {
    if (side == 'LONG') {
      return (currentPrice - entryPrice) * quantity;
    } else {
      return (entryPrice - currentPrice) * quantity;
    }
  }

  double get pnlPercent {
    if (side == 'LONG') {
      return ((currentPrice - entryPrice) / entryPrice) * 100;
    } else {
      return ((entryPrice - currentPrice) / entryPrice) * 100;
    }
  }

  double get notional {
    return currentPrice * quantity;
  }
}

class PortfolioProvider extends ChangeNotifier {
  double _initialCapital = 10000.0;
  double _currentEquity = 10000.0;
  List<Position> _positions = [];
  List<Map<String, dynamic>> _closedTrades = [];

  double get initialCapital => _initialCapital;
  double get currentEquity => _currentEquity;
  List<Position> get positions => _positions;
  List<Map<String, dynamic>> get closedTrades => _closedTrades;

  double get totalPnL {
    double pnl = 0;
    for (var position in _positions) {
      pnl += position.pnl;
    }
    for (var trade in _closedTrades) {
      pnl += trade['pnl'] as double;
    }
    return pnl;
  }

  double get totalPnLPercent {
    if (_initialCapital == 0) return 0;
    return (totalPnL / _initialCapital) * 100;
  }

  double get winRate {
    if (_closedTrades.isEmpty) return 0;
    final wins = _closedTrades.where((t) => (t['pnl'] as double) > 0).length;
    return (wins / _closedTrades.length) * 100;
  }

  double get avgRR {
    if (_closedTrades.isEmpty) return 0;
    final totalRR = _closedTrades.fold<double>(
      0,
      (sum, trade) => sum + (trade['rr'] as double),
    );
    return totalRR / _closedTrades.length;
  }

  PortfolioProvider() {
    _initializeMockPositions();
  }

  void _initializeMockPositions() {
    _positions = [
      Position(
        symbol: 'BTC/USDT',
        side: 'LONG',
        quantity: 0.1,
        entryPrice: 62000.0,
        currentPrice: 63250.0,
        openedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Position(
        symbol: 'EUR/USD',
        side: 'SHORT',
        quantity: 10000.0,
        entryPrice: 1.0900,
        currentPrice: 1.0850,
        openedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];

    _closedTrades = [
      {
        'symbol': 'SPX',
        'side': 'LONG',
        'pnl': 250.0,
        'rr': 1.8,
        'closedAt': DateTime.now().subtract(const Duration(hours: 8)),
      },
      {
        'symbol': 'GOLD',
        'side': 'LONG',
        'pnl': -150.0,
        'rr': 0.5,
        'closedAt': DateTime.now().subtract(const Duration(hours: 12)),
      },
      {
        'symbol': 'ETH/USDT',
        'side': 'SHORT',
        'pnl': 180.0,
        'rr': 1.5,
        'closedAt': DateTime.now().subtract(const Duration(hours: 24)),
      },
    ];

    _updateEquity();
  }

  void _updateEquity() {
    double positionsPnL = 0;
    for (var position in _positions) {
      positionsPnL += position.pnl;
    }
    double closedPnL = 0;
    for (var trade in _closedTrades) {
      closedPnL += trade['pnl'] as double;
    }
    _currentEquity = _initialCapital + positionsPnL + closedPnL;
    notifyListeners();
  }

  void addPosition(Position position) {
    _positions.add(position);
    _updateEquity();
  }

  void closePosition(int index) {
    if (index >= 0 && index < _positions.length) {
      final position = _positions[index];
      _closedTrades.add({
        'symbol': position.symbol,
        'side': position.side,
        'pnl': position.pnl,
        'rr': 1.5, // Mock value
        'closedAt': DateTime.now(),
      });
      _positions.removeAt(index);
      _updateEquity();
    }
  }

  void updatePositionPrice(int index, double newPrice) {
    if (index >= 0 && index < _positions.length) {
      final position = _positions[index];
      _positions[index] = Position(
        symbol: position.symbol,
        side: position.side,
        quantity: position.quantity,
        entryPrice: position.entryPrice,
        currentPrice: newPrice,
        openedAt: position.openedAt,
      );
      _updateEquity();
    }
  }
}

