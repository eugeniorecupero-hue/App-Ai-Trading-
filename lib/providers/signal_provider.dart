import 'package:flutter/material.dart';

class Signal {
  final String id;
  final String symbol;
  final String side; // LONG or SHORT
  final double entry;
  final double stop;
  final double target;
  final double size;
  final double confidence;
  final String reason;
  final String regime;
  final String volatility;
  final DateTime createdAt;
  final String status; // active, closed, hit_tp, hit_sl

  Signal({
    required this.id,
    required this.symbol,
    required this.side,
    required this.entry,
    required this.stop,
    required this.target,
    required this.size,
    required this.confidence,
    required this.reason,
    required this.regime,
    required this.volatility,
    required this.createdAt,
    required this.status,
  });

  double get riskReward {
    if (side == 'LONG') {
      return (target - entry) / (entry - stop);
    } else {
      return (entry - target) / (stop - entry);
    }
  }
}

class SignalProvider extends ChangeNotifier {
  List<Signal> _signals = [];

  List<Signal> get signals => _signals;

  SignalProvider() {
    _initializeMockSignals();
  }

  void _initializeMockSignals() {
    _signals = [
      Signal(
        id: '1',
        symbol: 'BTC/USDT',
        side: 'LONG',
        entry: 63250.00,
        stop: 61980.00,
        target: 65100.00,
        size: 0.75,
        confidence: 62.5,
        reason: 'Momentum + MACD↑, filtro news OK',
        regime: 'Trend moderato',
        volatility: '↑ Alto',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'active',
      ),
      Signal(
        id: '2',
        symbol: 'EUR/USD',
        side: 'SHORT',
        entry: 1.0850,
        stop: 1.0920,
        target: 1.0750,
        size: 0.50,
        confidence: 55.0,
        reason: 'RSI overbought, resistenza rotta',
        regime: 'Range',
        volatility: '↓ Basso',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        status: 'active',
      ),
      Signal(
        id: '3',
        symbol: 'SPX',
        side: 'LONG',
        entry: 5850.00,
        stop: 5750.00,
        target: 5950.00,
        size: 1.0,
        confidence: 58.0,
        reason: 'Breakout sopra SMA20, volume crescente',
        regime: 'Trend rialzista',
        volatility: '↑ Medio',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        status: 'closed',
      ),
      Signal(
        id: '4',
        symbol: 'GOLD',
        side: 'LONG',
        entry: 2080.00,
        stop: 2050.00,
        target: 2120.00,
        size: 0.60,
        confidence: 51.0,
        reason: 'Supporto testato, inversione possibile',
        regime: 'Range',
        volatility: '↑ Medio',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        status: 'closed',
      ),
      Signal(
        id: '5',
        symbol: 'ETH/USDT',
        side: 'SHORT',
        entry: 2450.00,
        stop: 2550.00,
        target: 2350.00,
        size: 0.80,
        confidence: 60.0,
        reason: 'Divergenza bearish, resistenza rifiutata',
        regime: 'Trend ribassista',
        volatility: '↑ Alto',
        createdAt: DateTime.now(),
        status: 'active',
      ),
    ];
  }

  void addSignal(Signal signal) {
    _signals.insert(0, signal);
    notifyListeners();
  }

  void updateSignalStatus(String signalId, String newStatus) {
    final index = _signals.indexWhere((s) => s.id == signalId);
    if (index != -1) {
      _signals[index] = Signal(
        id: _signals[index].id,
        symbol: _signals[index].symbol,
        side: _signals[index].side,
        entry: _signals[index].entry,
        stop: _signals[index].stop,
        target: _signals[index].target,
        size: _signals[index].size,
        confidence: _signals[index].confidence,
        reason: _signals[index].reason,
        regime: _signals[index].regime,
        volatility: _signals[index].volatility,
        createdAt: _signals[index].createdAt,
        status: newStatus,
      );
      notifyListeners();
    }
  }
}

