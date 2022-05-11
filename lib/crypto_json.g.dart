// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CryptoModel _$CryptoModelFromJson(Map<String, dynamic> json) => CryptoModel(
      currency: json['asset_id_quote'] as String,
      rate: (json['rate'] as num).toDouble(),
      crypto: json['asset_id_base'] as String,
    );

Map<String, dynamic> _$CryptoModelToJson(CryptoModel instance) =>
    <String, dynamic>{
      'asset_id_base': instance.crypto,
      'asset_id_quote': instance.currency,
      'rate': instance.rate,
    };
