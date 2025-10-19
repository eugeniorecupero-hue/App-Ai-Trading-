import 'package:flutter/material.dart';

class NewsItem {
  final String title;
  final String source;
  final String sentiment; // positive, neutral, negative
  final String timeAgo;
  final String url;

  NewsItem({
    required this.title,
    required this.source,
    required this.sentiment,
    required this.timeAgo,
    required this.url,
  });
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final List<NewsItem> _news = [
    NewsItem(
      title: 'Fed mantiene tassi stabili, mercati reagiscono positivamente',
      source: 'Reuters',
      sentiment: 'positive',
      timeAgo: '2 ore fa',
      url: 'https://reuters.com',
    ),
    NewsItem(
      title: 'Bitcoin consolida sopra 63.000, analisti rialzisti',
      source: 'CoinDesk',
      sentiment: 'positive',
      timeAgo: '4 ore fa',
      url: 'https://coindesk.com',
    ),
    NewsItem(
      title: 'Mercati azionari in calo per timori di recessione',
      source: 'Bloomberg',
      sentiment: 'negative',
      timeAgo: '6 ore fa',
      url: 'https://bloomberg.com',
    ),
    NewsItem(
      title: 'Euro stabile contro dollaro, focus su dati inflazione',
      source: 'Financial Times',
      sentiment: 'neutral',
      timeAgo: '8 ore fa',
      url: 'https://ft.com',
    ),
    NewsItem(
      title: 'Oro sale a nuovi massimi storici, domanda di safe-haven',
      source: 'MarketWatch',
      sentiment: 'positive',
      timeAgo: '10 ore fa',
      url: 'https://marketwatch.com',
    ),
    NewsItem(
      title: 'Petrolio scende su preoccupazioni domanda globale',
      source: 'CNBC',
      sentiment: 'negative',
      timeAgo: '12 ore fa',
      url: 'https://cnbc.com',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _news.length,
      itemBuilder: (context, index) {
        final newsItem = _news[index];
        return _buildNewsCard(newsItem);
      },
    );
  }

  Widget _buildNewsCard(NewsItem news) {
    String sentimentEmoji;
    Color sentimentColor;

    switch (news.sentiment) {
      case 'positive':
        sentimentEmoji = '😊';
        sentimentColor = const Color(0xFF10B981);
        break;
      case 'negative':
        sentimentEmoji = '😞';
        sentimentColor = const Color(0xFFEF4444);
        break;
      default:
        sentimentEmoji = '😐';
        sentimentColor = const Color(0xFF9CA3AF);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF374151)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sentimentEmoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Fonte: ${news.source}',
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            news.timeAgo,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: sentimentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sentiment: ${news.sentiment.toUpperCase()}',
                    style: TextStyle(
                      color: sentimentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Apri: ${news.url}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text(
                      'Leggi →',
                      style: TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
  }
}

