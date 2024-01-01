import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class AdapterStateTile extends StatelessWidget {
  const AdapterStateTile({
    Key? key,
    required this.state,
  }) : super(key: key);

  final BluetoothAdapterState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: ListTile(
        title: Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.titleSmall,
        ),
        trailing: Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.titleSmall?.color,
        ),
      ),
    );
  }
}
