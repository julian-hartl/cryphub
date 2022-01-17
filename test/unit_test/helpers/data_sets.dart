// taken from https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyListingsLatest
import 'package:cryphub/domain/crypto_currency/crypto_currency.dart';

final latestDataJson = {
  "data": [
    {
      "id": 1,
      "name": "Bitcoin",
      "symbol": "BTC",
      "slug": "bitcoin",
      "cmc_rank": 5,
      "num_market_pairs": 500,
      "circulating_supply": 16950100,
      "total_supply": 16950100,
      "max_supply": 21000000,
      "last_updated": "2018-06-02T22:51:28.209Z",
      "date_added": "2013-04-28T00:00:00.000Z",
      "tags": ["mineable"],
      "platform": null,
      "quote": {
        "USD": {
          "price": 9283.92,
          "volume_24h": 7155680000,
          "volume_change_24h": -0.152774,
          "percent_change_1h": -0.152774,
          "percent_change_24h": 0.518894,
          "percent_change_7d": 0.986573,
          "market_cap": 852164659250.2758,
          "market_cap_dominance": 51,
          "fully_diluted_market_cap": 952835089431.14,
          "last_updated": "2018-08-09T22:53:32.000Z"
        },
        "BTC": {
          "price": 1,
          "volume_24h": 772012,
          "volume_change_24h": 0,
          "percent_change_1h": 0,
          "percent_change_24h": 0,
          "percent_change_7d": 0,
          "market_cap": 17024600,
          "market_cap_dominance": 12,
          "fully_diluted_market_cap": 952835089431.14,
          "last_updated": "2018-08-09T22:53:32.000Z"
        }
      }
    },
    {
      "id": 1027,
      "name": "Ethereum",
      "symbol": "ETH",
      "slug": "ethereum",
      "num_market_pairs": 6360,
      "circulating_supply": 16950100,
      "total_supply": 16950100,
      "max_supply": 21000000,
      "last_updated": "2018-06-02T22:51:28.209Z",
      "date_added": "2013-04-28T00:00:00.000Z",
      "tags": ["mineable"],
      "platform": null,
      "quote": {
        "USD": {
          "price": 1283.92,
          "volume_24h": 7155680000,
          "volume_change_24h": -0.152774,
          "percent_change_1h": -0.152774,
          "percent_change_24h": 0.518894,
          "percent_change_7d": 0.986573,
          "market_cap": 158055024432,
          "market_cap_dominance": 51,
          "fully_diluted_market_cap": 952835089431.14,
          "last_updated": "2018-08-09T22:53:32.000Z"
        },
        "ETH": {
          "price": 1,
          "volume_24h": 772012,
          "volume_change_24h": -0.152774,
          "percent_change_1h": 0,
          "percent_change_24h": 0,
          "percent_change_7d": 0,
          "market_cap": 17024600,
          "market_cap_dominance": 12,
          "fully_diluted_market_cap": 952835089431.14,
          "last_updated": "2018-08-09T22:53:32.000Z"
        }
      }
    }
  ],
  "status": {
    "timestamp": "2018-06-02T22:51:28.209Z",
    "error_code": 0,
    "error_message": "",
    "elapsed": 10,
    "credit_count": 1
  }
};
final fakeCurrency = CryptoCurrency(
  currentPrice: 9283.92,
  percentChange1h: -0.152774,
  percentChange24h: 0.518894,
  percentChange7d: 0.986573,
  symbol: "BTC",
  iconUrl: "https://s2.coinmarketcap.com/static/img/coins/64x64/1.png",
  name: "Bitcoin",
  currency: Currency.usd,
  priceLastUpdated: DateTime.parse("2018-08-09T22:53:32.000Z"),
  id: 1,
);

final fakeCryptoCurrencies = List.generate(20, (index) => fakeCurrency);

final latestCurrencies = [
  CryptoCurrency(
    currentPrice: 9283.92,
    percentChange1h: -0.152774,
    percentChange24h: 0.518894,
    percentChange7d: 0.986573,
    symbol: "BTC",
    iconUrl: "https://s2.coinmarketcap.com/static/img/coins/64x64/1.png",
    name: "Bitcoin",
    currency: Currency.usd,
    priceLastUpdated: DateTime.parse("2018-08-09T22:53:32.000Z"),
    id: 1,
  ),
  CryptoCurrency(
    currentPrice: 1283.92,
    percentChange1h: -0.152774,
    percentChange24h: 0.518894,
    percentChange7d: 0.986573,
    symbol: "ETH",
    iconUrl: "https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png",
    name: "Ethereum",
    currency: Currency.usd,
    priceLastUpdated: DateTime.parse("2018-08-09T22:53:32.000Z"),
    id: 1027,
  )
];

final quotesLatestCurrencies = latestCurrencies;

const quotesLatestIds = [1, 1027];
const quotesLatestSymbols = ["BTC", "ETH"];

const quotesLatestIdsDataJson = {
  "data": {
    "1": {
      "id": 1,
      "name": "Bitcoin",
      "symbol": "BTC",
      "slug": "bitcoin",
      "cmc_rank": 5,
      "num_market_pairs": 500,
      "circulating_supply": 16950100,
      "total_supply": 16950100,
      "max_supply": 21000000,
      "last_updated": "2018-06-02T22:51:28.209Z",
      "date_added": "2013-04-28T00:00:00.000Z",
      "tags": ["mineable"],
      "platform": null,
      "quote": {
        "USD": {
          "price": 9283.92,
          "volume_24h": 7155680000,
          "volume_change_24h": -0.152774,
          "percent_change_1h": -0.152774,
          "percent_change_24h": 0.518894,
          "percent_change_7d": 0.986573,
          "market_cap": 852164659250.2758,
          "market_cap_dominance": 51,
          "fully_diluted_market_cap": 952835089431.14,
          "last_updated": "2018-08-09T22:53:32.000Z"
        },
        "BTC": {
          "price": 1,
          "volume_24h": 772012,
          "volume_change_24h": 0,
          "percent_change_1h": 0,
          "percent_change_24h": 0,
          "percent_change_7d": 0,
          "market_cap": 17024600,
          "market_cap_dominance": 12,
          "fully_diluted_market_cap": 952835089431.14,
          "last_updated": "2018-08-09T22:53:32.000Z"
        }
      }
    },
    "1027": {
      "id": 1027,
      "name": "Ethereum",
      "symbol": "ETH",
      "slug": "ethereum",
      "num_market_pairs": 6360,
      "circulating_supply": 16950100,
      "total_supply": 16950100,
      "max_supply": 21000000,
      "last_updated": "2018-06-02T22:51:28.209Z",
      "date_added": "2013-04-28T00:00:00.000Z",
      "tags": ["mineable"],
      "platform": null,
      "quote": {
        "USD": {
          "price": 1283.92,
          "volume_24h": 7155680000,
          "volume_change_24h": -0.152774,
          "percent_change_1h": -0.152774,
          "percent_change_24h": 0.518894,
          "percent_change_7d": 0.986573,
          "market_cap": 158055024432,
          "market_cap_dominance": 51,
          "fully_diluted_market_cap": 952835089431.14,
          "last_updated": "2018-08-09T22:53:32.000Z"
        },
        "ETH": {
          "price": 1,
          "volume_24h": 772012,
          "volume_change_24h": -0.152774,
          "percent_change_1h": 0,
          "percent_change_24h": 0,
          "percent_change_7d": 0,
          "market_cap": 17024600,
          "market_cap_dominance": 12,
          "fully_diluted_market_cap": 952835089431.14,
          "last_updated": "2018-08-09T22:53:32.000Z"
        }
      }
    }
  },
  "status": {
    "timestamp": "2018-06-02T22:51:28.209Z",
    "error_code": 0,
    "error_message": "",
    "elapsed": 10,
    "credit_count": 1
  }
};

const quotesLatestSymbolsDataJson = {
  "data": {
    "BTC": {
      "id": 1,
      "name": "Bitcoin",
      "symbol": "BTC",
      "slug": "bitcoin",
      "cmc_rank": 5,
      "num_market_pairs": 500,
      "circulating_supply": 16950100,
      "total_supply": 16950100,
      "max_supply": 21000000,
      "last_updated": "2018-06-02T22:51:28.209Z",
      "date_added": "2013-04-28T00:00:00.000Z",
      "tags": ["mineable"],
      "platform": null,
      "quote": {
        "USD": {
          "price": 9283.92,
          "volume_24h": 7155680000,
          "volume_change_24h": -0.152774,
          "percent_change_1h": -0.152774,
          "percent_change_24h": 0.518894,
          "percent_change_7d": 0.986573,
          "market_cap": 852164659250.2758,
          "market_cap_dominance": 51,
          "fully_diluted_market_cap": 952835089431.14,
          "last_updated": "2018-08-09T22:53:32.000Z"
        },
        "BTC": {
          "price": 1,
          "volume_24h": 772012,
          "volume_change_24h": 0,
          "percent_change_1h": 0,
          "percent_change_24h": 0,
          "percent_change_7d": 0,
          "market_cap": 17024600,
          "market_cap_dominance": 12,
          "fully_diluted_market_cap": 952835089431.14,
          "last_updated": "2018-08-09T22:53:32.000Z"
        }
      }
    },
    "ETH": {
      "id": 1027,
      "name": "Ethereum",
      "symbol": "ETH",
      "slug": "ethereum",
      "num_market_pairs": 6360,
      "circulating_supply": 16950100,
      "total_supply": 16950100,
      "max_supply": 21000000,
      "last_updated": "2018-06-02T22:51:28.209Z",
      "date_added": "2013-04-28T00:00:00.000Z",
      "tags": ["mineable"],
      "platform": null,
      "quote": {
        "USD": {
          "price": 1283.92,
          "volume_24h": 7155680000,
          "volume_change_24h": -0.152774,
          "percent_change_1h": -0.152774,
          "percent_change_24h": 0.518894,
          "percent_change_7d": 0.986573,
          "market_cap": 158055024432,
          "market_cap_dominance": 51,
          "fully_diluted_market_cap": 952835089431.14,
          "last_updated": "2018-08-09T22:53:32.000Z"
        },
        "ETH": {
          "price": 1,
          "volume_24h": 772012,
          "volume_change_24h": -0.152774,
          "percent_change_1h": 0,
          "percent_change_24h": 0,
          "percent_change_7d": 0,
          "market_cap": 17024600,
          "market_cap_dominance": 12,
          "fully_diluted_market_cap": 952835089431.14,
          "last_updated": "2018-08-09T22:53:32.000Z"
        }
      }
    }
  },
  "status": {
    "timestamp": "2018-06-02T22:51:28.209Z",
    "error_code": 0,
    "error_message": "",
    "elapsed": 10,
    "credit_count": 1
  }
};
