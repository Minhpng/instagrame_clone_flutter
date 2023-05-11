import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

extension OptionalFixNullNumber<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void increment() {
    state = state == null ? 1 : state + 1;
  }

  void resetCounter() {
    state = null;
  }

  // int? get value => state;
}

final counterProvider =
    StateNotifierProvider<Counter, int?>((ref) => Counter());

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  Consumer showCount() {
    return Consumer(builder: (context, ref, child) {
      final count = ref.watch(counterProvider);
      final text = count ?? 'Press add button';
      return Text(text.toString());
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: showCount(),
        actions: [
          IconButton(
              onPressed: ref.read(counterProvider.notifier).resetCounter,
              icon: const Icon(Icons.restart_alt))
        ],
      ),
      body: Center(
        child: Container(
          child: showCount(),
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: ref.read(counterProvider.notifier).increment,
        icon: Icon(Icons.add),
      ),
    );
  }
}
