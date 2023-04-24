ENV["POLY_API_ENDPOINT"] = "LIVE"
ENV["POLY_API_KEY_ID"] = ""
ENV["POLY_REAL_TIME"] = true
ENV["POLY_MAX_RANGE"] = 10

using PolygonAPI
c = PolygonAPI.credentials()
PolygonAPI.HEADER(c)

using Dates

DATE_FIN = PolygonAPI.get_time()
MAX_DATE = Dates.Year(9)
DATE_INI = DATE_FIN - MAX_DATE
DATE_FIN_DEF = Dates.format(DATE_FIN, "yyyy-mm-dd")
DATE_INI_DEF = Dates.format(DATE_INI, "yyyy-mm-dd")


c.ENDPOINT
c.KEY_ID
c.REAL_TIME
c.MAX_RANGE
#Market

PolygonAPI.get_market_holidays(c)
status = PolygonAPI.get_market_status(c)



a = PolygonAPI.get_agg(c, "AAPL", 1, PolygonAPI.day, "2022-10-10", "2022-10-12")
a.results[1].otc
b = PolygonAPI.get_daily_aggs(c, "2022-10-12")

b.results[1].otc

d = PolygonAPI.get_daily_bar(c, "2022-10-10", "AAPL")
d.from
d.otc

d = PolygonAPI.get_previous_agg(c, "AAPL")

d.results[1].timestamp

e = PolygonAPI.get_ticker_details(c, "AAPL")
e.currency_name
e.cik
e.delisted_utc
e.market_cap
e.share_class_shares_outstanding

f = PolygonAPI.get_tickers_details(c)

g = PolygonAPI.get_snaps(c)

h = PolygonAPI.get_gainers_snap(c)
i = PolygonAPI.get_losers_snap(c)

j = PolygonAPI.get_snap(c, "AAPL")

k = PolygonAPI.get_agg(c, "AAPL", 1, PolygonAPI.day, DATE_INI_DEF, DATE_FIN_DEF)


k1 = filter(a -> a.type == "CS", f)
k2 = map(a -> a.ticker, k1)
k3 = map(a -> PolygonAPI.get_agg(c, a, 1, PolygonAPI.day, DATE_INI_DEF, DATE_FIN_DEF), k2)
k4 = map(a -> (a.ticker, a.results), k3)

l = PolygonAPI.get_trades(c, "AAPL", timestamp="2023-04-21")
m = PolygonAPI.get_last_trade(c, "AAPL")

n = PolygonAPI.get_sma(c, "AAPL", PolygonAPI.day)
o = PolygonAPI.get_ema(c, "AAPL", PolygonAPI.day)


