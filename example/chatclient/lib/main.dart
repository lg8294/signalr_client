import 'dart:io';

import 'package:chatclient/app.dart';
import 'package:flutter/material.dart';
import 'package:http_proxy/http_proxy.dart';

// const kChatServerUrl = "http://192.168.10.50:51002";
const kChatServerUrl = 'https://message-ws-stg.kangfx.com/messagebroker';
const kAccessToken =
    'eyJhbGciOiJSUzI1NiIsImtpZCI6ImE3YzY1NzkyNjU2MDRhZDg5MmM4NmEwMWYzNzk2OTZlIiwidHlwIjoiSldUIn0.eyJuYmYiOjE2Mzg4NDExNTIsImV4cCI6MTY0MDEzNzE1MiwiaXNzIjoiaHR0cHM6Ly9hcGktc3RnLmthbmdmeC5jb20vaWRlbnRpdHkiLCJhdWQiOlsiaHR0cHM6Ly9hcGktc3RnLmthbmdmeC5jb20vaWRlbnRpdHkvcmVzb3VyY2VzIiwiaWRlbnRpdHkiLCJpbSIsImRpY3Rpb25hcnkiLCJ2aXNpdCIsInRyYWluaW5nIiwicmVmZXJyYWwiLCJtZXNzYWdlIiwic2F0aXNmYWN0b3J5IiwiY2Fyb3VzZWwiLCJjb250ZW50IiwiZmlsZXNlcnZpY2UiXSwiY2xpZW50X2lkIjoiYjk0MmY2ZmMtMTViNS0xMWVhLTk1ODMtMDAwYzI5MDI2NzAwIiwic3ViIjoiZGY1OTU0ZTQtNjJjOC00MGE2LTg5OGQtODgwZGJkNWFkMzAwIiwiYXV0aF90aW1lIjoxNjM4ODQxMTUyLCJpZHAiOiJsb2NhbCIsIm9yZ2FuaXphdGlvbiI6Ilt7XCJpZFwiOlwiYTQ4NTNiNDItZWQxZi00NGFmLTg4YzQtOTVlNjM0NGFiMTVkXCIsXCJuYW1lXCI6XCLlm5vlt53lrp3nn7PoirHljLvpmaJcIixcImlzRGVmYXVsdFwiOlwiVHJ1ZVwiLFwiaXNBdXRob3JpemF0aW9uXCI6XCJGYWxzZVwifV0iLCJ1c2VyX25hbWUiOiJ3eHQwMDEiLCJuYW1lIjoi5LiH5bCP5am3MDAxIiwibmlja25hbWUiOiLkuIflsI_lqbcwMDEiLCJyb2xlIjoiZG9jdG9yIiwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsImlkZW50aXR5IiwiaW0iLCJkaWN0aW9uYXJ5IiwidmlzaXQiLCJ0cmFpbmluZyIsInJlZmVycmFsIiwiU01TIiwiUHVzaCIsIlNhdGlzZmFjdGlvbk1hbmFnZSIsImNhcm91c2VsIiwiY29udGVudCIsImZpbGVzZXJ2aWNlIiwib2ZmbGluZV9hY2Nlc3MiXSwiYW1yIjpbInB3ZCJdfQ.I7YQ0ipjnEPf9d6TmC6LLsPDpPxYDjBLJ-0IHXSYLIc84nL6uG3KJ3b79REIAlx4i0Hke9B8mWE840d-VapU4O93idbqIIwuelnR6epSwp7PSfVC1bScNWbai-WbO7m5Go0-Vtuih5sYzjsk_PsJyHR4ysfgQxP0nHm-w_1Cj8P9DzkOzQBG44WRipCuJuhqaIrI_ksrWL5c1ORrAUoZXSVnsLNfLJVh0sJhpVsV-eO64AzMJz7aiq9JeDLHlvtMpS0SDTZQlBBHWp4cNFeL6exqzFzsL0PLOyRXJvh23W5ZL7rukhlxhmSiMpipXN4Nkb8C_XdRO3SeFByz_LAWxg';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configHttpProxy();
  runApp(App());
}

Future<void> configHttpProxy() async {
  // 使用系统代理
  HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  HttpOverrides.global = httpProxy;
  print('HTTP 代理：${httpProxy.host}:${httpProxy.port}');
}
