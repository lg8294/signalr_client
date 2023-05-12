import 'package:client/main.dart';
import 'package:client/utils/viewModel/viewModelPropertyWidgetBuilder.dart';
import 'package:client/views/pages/chatPageViewModel.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatPageViewModel vm = ChatPageViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChatPageViewModelProvider(
        viewModel: vm,
        childBuilder: (ctx) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Server at: $kChatServerUrl"),
                centerTitle: true,
              ),
              resizeToAvoidBottomInset: false,
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: const <Widget>[
                    MessageComposeView(),
                    Divider(),
                    Expanded(
                      child: MessageChatView(),
                    ),
                  ],
                ),
              ));
        });
  }
}

class MessageChatView extends StatelessWidget {
  const MessageChatView({Key? key}) : super(key: key);

  // Properites

  // Methods
  @override
  Widget build(BuildContext context) {
    final vm = ChatPageViewModelProvider.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              "Messages:",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            ViewModelPropertyWidgetBuilder<bool>(
                viewModel: vm,
                propertyName: ChatPageViewModel.connectionIsOpenPropName,
                builder: (context, snapshot) {
                  return Text(
                      vm.connectionIsOpen ? "Connected" : "Disconnected");
                }),
          ],
        ),
        Expanded(
            child: ViewModelPropertyWidgetBuilder<ChatMessage>(
          viewModel: vm,
          propertyName: ChatPageViewModel.chatMessagesPropName,
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: vm.chatMessages.length,
                itemBuilder: (BuildContext ctx, int index) =>
                    _createMessageItemView(vm.chatMessages[index]));
          },
        )),
      ],
    );
  }

  Widget _createMessageItemView(ChatMessage message) {
    return Column(children: <Widget>[
      ListTile(
          leading: Text("${message.senderName} :"),
          title: Text(message.message)),
      const Divider(),
    ]);
  }
}

class MessageComposeView extends StatefulWidget {
  const MessageComposeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessageComposeViewState();
}

class _MessageComposeViewState extends State<MessageComposeView> {
  // Properties
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  // Methods

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _messageTextController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ChatPageViewModelProvider.of(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ViewModelPropertyWidgetBuilder<String>(
            viewModel: vm,
            propertyName: ChatPageViewModel.userNamePropName,
            builder: (context, snapshot) {
              return ElevatedButton(
                child: Text("${vm.userName} says"),
                onPressed: _handleUpdateUserName,
              );
            }),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _messageTextController,
                decoration: const InputDecoration(
                    labelText: 'Your message:', hintText: 'eg. Hi there!'),
              ),
            ),
            ElevatedButton(
              child: const Text("send"),
              onPressed: () => vm.sendChatMessage(_messageTextController.text),
            )
          ],
        )
      ],
    );
  }

  void _handleUpdateUserName() async {
    final vm = ChatPageViewModelProvider.of(context);
    await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _userNameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        labelText: 'Your Name', hintText: 'eg. John Smith'),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    vm.userName = _userNameController.text;
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}
