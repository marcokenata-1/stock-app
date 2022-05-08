class StockDetails {
  final String symbol;
  final String lastRefreshed;
  final String timezone;
  final Map<String, dynamic> weeklyPrice;

  StockDetails.fromJson(json)
      : symbol = json['Meta Data']['2. Symbol'],
        lastRefreshed = json['Meta Data']['3. Last Refreshed'],
        timezone = json['Meta Data']['5. Time Zone'],
        weeklyPrice = json['Time Series (Daily)'];
}
