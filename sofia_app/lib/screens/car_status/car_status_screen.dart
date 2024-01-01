import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofia_app/custom/light_warning_message.dart';
import 'package:sofia_app/custom/out_of_service_message.dart';
import 'package:sofia_app/enums/direction.dart';
import 'package:sofia_app/providers/ble_provider.dart';
import 'package:sofia_app/screens/home/home_screen.dart';
import '../../configs/index.dart';

class CarStatusScreen extends StatelessWidget {
  const CarStatusScreen({Key? key}) : super(key: key);
  final inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(carStatus),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(size_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text(
                      carPosition,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 10, color: Colors.blue),
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Text(
                        context.watch<BleProvider>().carFloor.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  elevator,
                  width: 80,
                  height: 80,
                ),
                if (context.watch<BleProvider>().carDirection == Direction.up)
                  Image.asset(
                    up,
                    width: 40,
                  ),
                if (context.watch<BleProvider>().carDirection == Direction.down)
                  Image.asset(
                    down,
                    width: 40,
                  )
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: inProgress
                  ? const Text(
                      "In Progress of Destination Floor Data ") // Show a progress indicator if inProgress is true
                  : const Text(
                      etaToFloor,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            if (!context.watch<BleProvider>().presenceOfLight)
              LightWarningMessage(message: warningAttentionforLight),
            const SizedBox(height: 8),
            Center(
              child: Text(
                estimatedTime,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: inProgress
                  ? const Text("Inprogress of change Destination button")
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text(
                        changeDestination,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            if (context.watch<BleProvider>().outOfService)
              OutOfServiceMessage(message: warningAttentionForOutOfService),
          ],
        ),
      ),
    );
  }
}
