import 'dart:async';

import 'package:flutter/material.dart';
import 'package:semsar/helpers/loading/loading_controller.dart';

class LoadingScreen {
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._instance();
  LoadingScreen._instance();

  LoadingController? controller;

  void show(
    BuildContext context,
    String text,
  ) {
    if (controller?.update(text) ?? false) {
      return;
    }
    controller = showOverLay(context, text);
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingController showOverLay(
    BuildContext context,
    String givenText,
  ) {
    final text = StreamController<String>();

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder(
                        stream: text.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data as String,
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return Container();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingController(
      close: () {
        text.close();
        overlay.remove();
        return true;
      },
      update: (grabedText) {
        text.add(grabedText);
        return true;
      },
    );
  }
}