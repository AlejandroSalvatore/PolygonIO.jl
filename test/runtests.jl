using PolygonAPI
using Dates
ENV["POLY_API_ENDPOINT"] = "LIVE"
ENV["POLY_API_KEY_ID"] = ""
ENV["POLY_REAL_TIME"] = true
ENV["POLY_MAX_RANGE"] = 10
c = credentials()

to = string(today())

from = string(today() -  Dates.Year(10))


bars(c, "AAPL", 2, PolygonAPI.week, "2023-03-13", "2023-04-14")
daily_bar(c, "2023-04-13", "AAPL")
market_status(c)
market_holidays(c)
daily_bars(c, "2023-04-13")
details(c, "AAPL")
details(c)
trades(c, "AAPL", timestamp="2023-04-13")
last_trade(c, "AAPL")

snap(c, "AAPL")
snaps(c)

sma(c, "AAPL", PolygonAPI.day, timestamp="2023-04-13")