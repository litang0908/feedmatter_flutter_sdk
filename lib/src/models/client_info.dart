import 'package:json_annotation/json_annotation.dart';

part 'client_info.g.dart';

@JsonSerializable()
class ClientInfo {
  final int appVersionCode;
  final String appVersionName;
  final String appPackage;
  final String appType;

  const ClientInfo({
    required this.appVersionCode,
    required this.appVersionName,
    required this.appPackage,
    required this.appType,
  });

  factory ClientInfo.fromJson(Map<String, dynamic> json) => _$ClientInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ClientInfoToJson(this);
} 