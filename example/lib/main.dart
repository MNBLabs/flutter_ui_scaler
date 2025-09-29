import 'package:flutter/material.dart';
import 'package:flutter_ui_scaler/flutter_ui_scaler.dart';

void main() => runApp(const Demo());

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return UiScaleScope(
      figmaW: 440,
      figmaH: 956,
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Builder(
              builder: (ctx) {
                final ds = ctx.ds; // from UiScaleScope extension
                return Container(
                  padding: EdgeInsets.all(ds.sx(24)),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(ds.sx(20)),
                  ),
                  child: Text(
                    'Hello scaled world',
                    style: TextStyle(fontSize: ds.sp(20)),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
