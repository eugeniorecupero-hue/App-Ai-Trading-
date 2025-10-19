from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime, timedelta
import random
import json

app = FastAPI(title="Atlas AI Trader Backend", version="1.0.0")

# CORS Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Models
class Signal(BaseModel):
    id: str
    symbol: str
    side: str  # LONG or SHORT
    entry: float
    stop: float
    target: float
    size: float
    confidence: float
    reason: str
    regime: str
    volatility: str
    created_at: datetime
    status: str  # active, closed, hit_tp, hit_sl

class MarketData(BaseModel):
    symbol: str
    price: float
    change: float
    change_percent: float
    asset_class: str

class Position(BaseModel):
    symbol: str
    side: str
    quantity: float
    entry_price: float
    current_price: float
    opened_at: datetime

class PortfolioStats(BaseModel):
    initial_capital: float
    current_equity: float
    total_pnl: float
    total_pnl_percent: float
    win_rate: float
    avg_rr: float
    positions_count: int
    closed_trades_count: int

class NewsItem(BaseModel):
    title: str
    source: str
    sentiment: str  # positive, neutral, negative
    time_ago: str
    url: str

# Mock Data
CRYPTO_MARKETS = [
    {"symbol": "BTC/USDT", "price": 63250.50, "change": 1250.50, "change_percent": 2.02, "asset_class": "Crypto"},
    {"symbol": "ETH/USDT", "price": 2450.75, "change": -85.25, "change_percent": -3.37, "asset_class": "Crypto"},
    {"symbol": "SOL/USDT", "price": 145.30, "change": 8.50, "change_percent": 6.22, "asset_class": "Crypto"},
    {"symbol": "XRP/USDT", "price": 2.85, "change": 0.15, "change_percent": 5.56, "asset_class": "Crypto"},
    {"symbol": "ADA/USDT", "price": 1.12, "change": -0.08, "change_percent": -6.67, "asset_class": "Crypto"},
]

FX_MARKETS = [
    {"symbol": "EUR/USD", "price": 1.0850, "change": 0.0025, "change_percent": 0.23, "asset_class": "FX"},
    {"symbol": "GBP/USD", "price": 1.2680, "change": -0.0050, "change_percent": -0.39, "asset_class": "FX"},
    {"symbol": "USD/JPY", "price": 149.50, "change": 1.25, "change_percent": 0.84, "asset_class": "FX"},
    {"symbol": "AUD/USD", "price": 0.6580, "change": 0.0015, "change_percent": 0.23, "asset_class": "FX"},
    {"symbol": "USD/CAD", "price": 1.3650, "change": -0.0025, "change_percent": -0.18, "asset_class": "FX"},
]

INDICES_MARKETS = [
    {"symbol": "SPX", "price": 5890.50, "change": 125.50, "change_percent": 2.18, "asset_class": "Indices"},
    {"symbol": "NDX", "price": 20150.75, "change": 450.75, "change_percent": 2.28, "asset_class": "Indices"},
    {"symbol": "DXY", "price": 104.25, "change": -0.50, "change_percent": -0.48, "asset_class": "Indices"},
    {"symbol": "VIX", "price": 14.50, "change": -1.25, "change_percent": -7.94, "asset_class": "Indices"},
    {"symbol": "FTSE", "price": 8150.25, "change": 85.25, "change_percent": 1.06, "asset_class": "Indices"},
]

COMMODITIES_MARKETS = [
    {"symbol": "GOLD", "price": 2085.50, "change": 25.50, "change_percent": 1.24, "asset_class": "Commodities"},
    {"symbol": "OIL (WTI)", "price": 78.45, "change": -1.55, "change_percent": -1.94, "asset_class": "Commodities"},
    {"symbol": "NATURAL GAS", "price": 2.85, "change": 0.15, "change_percent": 5.56, "asset_class": "Commodities"},
    {"symbol": "COPPER", "price": 4.25, "change": 0.08, "change_percent": 1.92, "asset_class": "Commodities"},
    {"symbol": "CORN", "price": 425.50, "change": -8.50, "change_percent": -1.96, "asset_class": "Commodities"},
]

SIGNALS = [
    {
        "id": "1",
        "symbol": "BTC/USDT",
        "side": "LONG",
        "entry": 63250.00,
        "stop": 61980.00,
        "target": 65100.00,
        "size": 0.75,
        "confidence": 62.5,
        "reason": "Momentum + MACD↑, filtro news OK",
        "regime": "Trend moderato",
        "volatility": "↑ Alto",
        "created_at": datetime.now() - timedelta(hours=2),
        "status": "active",
    },
    {
        "id": "2",
        "symbol": "EUR/USD",
        "side": "SHORT",
        "entry": 1.0850,
        "stop": 1.0920,
        "target": 1.0750,
        "size": 0.50,
        "confidence": 55.0,
        "reason": "RSI overbought, resistenza rotta",
        "regime": "Range",
        "volatility": "↓ Basso",
        "created_at": datetime.now() - timedelta(hours=5),
        "status": "active",
    },
]

NEWS = [
    {
        "title": "Fed mantiene tassi stabili, mercati reagiscono positivamente",
        "source": "Reuters",
        "sentiment": "positive",
        "time_ago": "2 ore fa",
        "url": "https://reuters.com",
    },
    {
        "title": "Bitcoin consolida sopra 63.000, analisti rialzisti",
        "source": "CoinDesk",
        "sentiment": "positive",
        "time_ago": "4 ore fa",
        "url": "https://coindesk.com",
    },
    {
        "title": "Mercati azionari in calo per timori di recessione",
        "source": "Bloomberg",
        "sentiment": "negative",
        "time_ago": "6 ore fa",
        "url": "https://bloomberg.com",
    },
]

# Routes
@app.get("/")
async def root():
    return {"message": "Atlas AI Trader Backend API", "version": "1.0.0"}

@app.get("/health")
async def health():
    return {"status": "healthy"}

@app.get("/signals", response_model=List[Signal])
async def get_signals(status: Optional[str] = None):
    """Get all signals or filter by status"""
    signals = [Signal(**s) for s in SIGNALS]
    if status:
        signals = [s for s in signals if s.status == status]
    return signals

@app.get("/signals/{signal_id}", response_model=Signal)
async def get_signal(signal_id: str):
    """Get a specific signal by ID"""
    for signal in SIGNALS:
        if signal["id"] == signal_id:
            return Signal(**signal)
    raise HTTPException(status_code=404, detail="Signal not found")

@app.post("/signals", response_model=Signal)
async def create_signal(signal: Signal):
    """Create a new signal"""
    signal_dict = signal.dict()
    SIGNALS.append(signal_dict)
    return signal

@app.get("/markets/crypto", response_model=List[MarketData])
async def get_crypto_markets():
    """Get cryptocurrency markets"""
    return [MarketData(**m) for m in CRYPTO_MARKETS]

@app.get("/markets/fx", response_model=List[MarketData])
async def get_fx_markets():
    """Get forex markets"""
    return [MarketData(**m) for m in FX_MARKETS]

@app.get("/markets/indices", response_model=List[MarketData])
async def get_indices_markets():
    """Get indices markets"""
    return [MarketData(**m) for m in INDICES_MARKETS]

@app.get("/markets/commodities", response_model=List[MarketData])
async def get_commodities_markets():
    """Get commodities markets"""
    return [MarketData(**m) for m in COMMODITIES_MARKETS]

@app.get("/markets/scan")
async def scan_markets(asset_class: Optional[str] = None):
    """Scan markets for top opportunities"""
    all_markets = CRYPTO_MARKETS + FX_MARKETS + INDICES_MARKETS + COMMODITIES_MARKETS
    
    if asset_class:
        all_markets = [m for m in all_markets if m["asset_class"].lower() == asset_class.lower()]
    
    # Sort by change_percent and return top 5
    sorted_markets = sorted(all_markets, key=lambda x: abs(x["change_percent"]), reverse=True)
    return sorted_markets[:5]

@app.get("/portfolio/stats", response_model=PortfolioStats)
async def get_portfolio_stats():
    """Get portfolio statistics"""
    return PortfolioStats(
        initial_capital=10000.0,
        current_equity=10425.50,
        total_pnl=425.50,
        total_pnl_percent=4.26,
        win_rate=66.67,
        avg_rr=1.6,
        positions_count=2,
        closed_trades_count=3,
    )

@app.get("/news", response_model=List[NewsItem])
async def get_news(sentiment: Optional[str] = None):
    """Get news items, optionally filtered by sentiment"""
    news = [NewsItem(**n) for n in NEWS]
    if sentiment:
        news = [n for n in news if n.sentiment == sentiment]
    return news

@app.post("/notifications/subscribe")
async def subscribe_notifications(token: str):
    """Subscribe to push notifications"""
    return {"message": "Subscribed to notifications", "token": token}

@app.get("/config")
async def get_config():
    """Get app configuration"""
    return {
        "version": "1.0.0",
        "api_endpoint": "http://localhost:8000",
        "update_interval": 60,
        "features": {
            "signals": True,
            "markets": True,
            "portfolio": True,
            "news": True,
            "notifications": True,
        },
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

