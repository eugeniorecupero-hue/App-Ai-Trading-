import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/signal_provider.dart';
import '../providers/portfolio_provider.dart';
import '../providers/market_provider.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeWelcomeMessages();
  }

  void _initializeWelcomeMessages() {
    _messages.addAll([
      ChatMessage(
        text: 'Benvenuto in Atlas AI Trader! 🚀\n\nSono il tuo assistente intelligente per l\'analisi dei mercati finanziari. Posso aiutarti con:\n\n• Segnali di trading (es. "BTC 1h", "EUR/USD 30m")\n• Scansioni di mercato (es. "/scan crypto", "/scan all")\n• Analisi del portafoglio (es. "/portfolio")\n• Notizie finanziarie (es. "/news")\n\nDigita "❓ Aiuto" per una guida completa.',
        isUser: false,
        timestamp: DateTime.now(),
      ),
      ChatMessage(
        text: 'Esempio di segnale:\n\n🔔 Segnale | BTC/USDT | 1H\n• Side: LONG (confidenza 62%)\n• Entry: 63.250 | Stop: 61.980 | Target: 65.100\n• Size: 0.75% NAV (RR ~1.8)\n• Regime: trend moderato | Vol: ↑\n• Motivo: momentum + MACD↑, filtro news OK\n\n⚠️ Info probabilistica, non consulenza finanziaria',
        isUser: false,
        timestamp: DateTime.now().add(const Duration(seconds: 2)),
      ),
    ]);
  }

  void _handleSendMessage() {
    if (_messageController.text.isEmpty) return;

    final userMessage = _messageController.text;
    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      String response = _generateResponse(userMessage);

      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: response,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });
      }
    });
  }

  String _generateResponse(String input) {
    final lowerInput = input.toLowerCase();

    if (lowerInput.contains('btc') && lowerInput.contains('1h')) {
      return '🔔 Segnale | BTC/USDT | 1H\n• Side: LONG (confidenza 62%)\n• Entry: 63.250 | Stop: 61.980 | Target: 65.100\n• Size: 0.75% NAV (RR ~1.8)\n• Regime: trend moderato | Vol: ↑\n• Motivo: momentum + MACD↑, filtro news OK\n\n⚠️ Info probabilistica, non consulenza finanziaria';
    } else if (lowerInput.contains('/scan') || lowerInput.contains('scan')) {
      return '📊 Top 5 Opportunità Crypto:\n\n1. SOL/USDT - LONG (58% conf) - RR: 2.1\n2. XRP/USDT - LONG (55% conf) - RR: 1.9\n3. ADA/USDT - SHORT (52% conf) - RR: 1.5\n4. BTC/USDT - LONG (62% conf) - RR: 1.8\n5. ETH/USDT - SHORT (60% conf) - RR: 1.6\n\nFiltra per asset class: /scan fx, /scan indices, /scan commodities';
    } else if (lowerInput.contains('/portfolio') || lowerInput.contains('portafoglio')) {
      final portfolio = context.read<PortfolioProvider>();
      return '💼 Portafoglio Paper Trading\n\nCapitale Iniziale: \$${portfolio.initialCapital.toStringAsFixed(2)}\nEquity Attuale: \$${portfolio.currentEquity.toStringAsFixed(2)}\nP/L Totale: \$${portfolio.totalPnL.toStringAsFixed(2)} (${portfolio.totalPnLPercent.toStringAsFixed(2)}%)\n\nMetriche:\n• Win Rate: ${portfolio.winRate.toStringAsFixed(1)}%\n• Avg RR: ${portfolio.avgRR.toStringAsFixed(2)}\n• Posizioni Aperte: ${portfolio.positions.length}\n• Trade Chiusi: ${portfolio.closedTrades.length}';
    } else if (lowerInput.contains('/news') || lowerInput.contains('news')) {
      return '📰 Ultime Notizie Finanziarie\n\n1. 😊 Fed mantiene tassi stabili\n   Fonte: Reuters | 2 ore fa\n\n2. 😐 Bitcoin consolida sopra 63k\n   Fonte: CoinDesk | 4 ore fa\n\n3. 😞 Mercati azionari in calo\n   Fonte: Bloomberg | 6 ore fa\n\nVedi tutte le notizie nella sezione News';
    } else if (lowerInput.contains('❓') || lowerInput.contains('aiuto') || lowerInput.contains('help')) {
      return '❓ Come chiedere all\'agente\n\n📌 Segnali di Trading:\n• "BTC 1h" - Segnale per Bitcoin su timeframe 1 ora\n• "EUR/USD 30m" - Segnale per coppia forex\n• "Top opportunità oggi" - Migliori setup attuali\n\n📌 Scansioni di Mercato:\n• "/scan crypto" - Top 5 crypto\n• "/scan fx" - Top 5 forex\n• "/scan all" - Tutte le asset class\n\n📌 Portafoglio:\n• "/portfolio" - Statistiche e posizioni\n• "/close BTC" - Chiudi posizione\n\n📌 Notizie:\n• "/news" - Ultime notizie\n• "/news crypto" - News crypto\n\n⚠️ Ricorda: I segnali sono informativi, non consulenza finanziaria!';
    } else {
      return 'Ho ricevuto: "$input"\n\nComandi disponibili:\n• Segnali: "BTC 1h", "EUR/USD 30m"\n• Scansioni: "/scan crypto", "/scan all"\n• Portafoglio: "/portfolio"\n• Notizie: "/news"\n• Aiuto: "❓ Aiuto"\n\nTenta uno di questi comandi!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length && _isLoading) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F2937),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final message = _messages[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: message.isUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (!message.isUser)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF3B82F6),
                              const Color(0xFF10B981),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'A',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFF1F2937),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          message.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    if (message.isUser) const SizedBox(width: 8),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1F2937),
            border: Border(
              top: BorderSide(
                color: const Color(0xFF374151),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Chiedi un segnale... (es. "BTC 1h")',
                    hintStyle: const TextStyle(
                      color: Color(0xFF6B7280),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: Color(0xFF374151),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (_) => _handleSendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: _handleSendMessage,
                mini: true,
                backgroundColor: const Color(0xFF3B82F6),
                child: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

