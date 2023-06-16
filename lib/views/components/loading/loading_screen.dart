import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/views/components/animations/loading_animation_view.dart';

import '../constants/strings.dart';
import 'loading_screen_controller.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  void show({required BuildContext context, String text = Strings.loading}) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = showOverlay(context: context, text: text);
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController? showOverlay(
      {required BuildContext context, required String text}) {
    final textController = StreamController<String>();

    textController.add(text);

    final state = Overlay.of(context);
    final renderbox = context.findRenderObject() as RenderBox;

    final size = renderbox.size;

    final overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
                maxHeight: size.height * 0.8,
                maxWidth: size.width * 0.8,
                minWidth: size.width * 0.5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder(
                        stream: textController.stream,
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.requireData,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.black87),
                            );
                          } else {
                            return Container();
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
    state.insert(overlay);
    return LoadingScreenController(close: () {
      overlay.remove();
      textController.close();
      return true;
    }, update: (text) {
      textController.add(text);
      return true;
    });
  }
}
