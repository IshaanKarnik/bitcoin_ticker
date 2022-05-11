import 'package:json_annotation/json_annotation.dart';

part 'crypto_json.g.dart';

// {
//   "time": "2017-08-09T14:31:18.3150000Z",
//   "asset_id_base": "BTC",
//   "asset_id_quote": "USD",
//   "rate": 3260.3514321215056208129867667
// }

@JsonSerializable()
class CryptoModel {
  @JsonKey(name: 'asset_id_base')
  final String crypto;

  @JsonKey(name: 'asset_id_quote')
  final String currency;

  @JsonKey(name: 'rate')
  final double rate;

  CryptoModel({
    required this.currency,
    required this.rate,
    required this.crypto,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) =>
      _$CryptoModelFromJson(json);
}
