import 'package:client/main.dart';
import 'package:client/utils/viewModel/viewModel.dart';
import 'package:client/utils/viewModel/viewModelProvider.dart';
import 'package:flutter/widgets.dart';
import 'package:lg_signalr_client/lg_signalr_client.dart';

import '../../main.dart';

typedef HubConnectionProvider = Future<HubConnection> Function();

class ChatMessage {
  // Properties
  final String senderName;
  final String message;

  // Methods
  ChatMessage(this.senderName, this.message);
}

class ChatPageViewModel extends ViewModel {
// Properties
  late String _serverUrl;
  HubConnection? _hubConnection;

  late List<ChatMessage> _chatMessages;
  static const String chatMessagesPropName = "chatMessages";
  List<ChatMessage> get chatMessages => _chatMessages;

  late bool _connectionIsOpen;
  static const String connectionIsOpenPropName = "connectionIsOpen";
  bool get connectionIsOpen => _connectionIsOpen;
  set connectionIsOpen(bool value) {
    updateValue(connectionIsOpenPropName, _connectionIsOpen, value,
        (v) => _connectionIsOpen = v as bool);
  }

  late String _userName;
  static const String userNamePropName = "userName";
  String get userName => _userName;
  set userName(String value) {
    updateValue(
        userNamePropName, _userName, value, (v) => _userName = v as String);
  }

// Methods

  ChatPageViewModel() {
    _serverUrl = kChatServerUrl; // + "/Chat";
    _chatMessages = [];
    _connectionIsOpen = false;
    _userName = "Fred";

    openChatConnection();
  }

  Future<void> openChatConnection() async {
    if (_hubConnection == null) {
      _hubConnection = HubConnectionBuilder()
          .withUrl(
            _serverUrl,
            options: HttpConnectionOptions(
              skipNegotiation: true,
              // transport: WebSocketTransport(),
              transport: HttpTransportType.WebSockets,
              accessTokenFactory: () async => kAccessToken,
            ),
            // transportType: HttpTransportType.WebSockets,
          )
          .build();
      _hubConnection!.onClose((error) => connectionIsOpen = false);
      _hubConnection!.on("OnMessage", _handleIncomingChatMessage);
    }

    if (_hubConnection!.state != HubConnectionState.Connected) {
      await _hubConnection!.start();
      connectionIsOpen = true;
    }
  }

  Future<void> sendChatMessage(String chatMessage) async {
    await openChatConnection();
    _hubConnection!.invoke("Send", args: <Object>[userName, chatMessage]);
  }

  void _handleIncomingChatMessage(List<Object> args) {
    final String senderName = args[0] as String;
    final String message = args[1] as String;
    _chatMessages.add(ChatMessage(senderName, message));
    notifyPropertyChanged(chatMessagesPropName);
  }
}

class ChatPageViewModelProvider extends ViewModelProvider<ChatPageViewModel> {
  // Properties

  // Methods
  ChatPageViewModelProvider({
    Key? key,
    required ChatPageViewModel viewModel,
    required WidgetBuilder childBuilder,
  }) : super(key: key, viewModel: viewModel, childBuilder: childBuilder);

  static ChatPageViewModel of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ChatPageViewModelProvider>()!
        .viewModel;
  }
}
