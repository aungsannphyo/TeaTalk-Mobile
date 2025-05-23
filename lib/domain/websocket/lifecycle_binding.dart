import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'auth_token_provider.dart';
import 'websocket_provider.dart';

class LifecycleBinding extends StatefulWidget {
  final Widget child;
  const LifecycleBinding({super.key, required this.child});

  @override
  State<LifecycleBinding> createState() => _LifecycleBindingState();
}

class _LifecycleBindingState extends State<LifecycleBinding>
    with WidgetsBindingObserver {
  late WidgetRef _ref;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _handleLifecycle(AppLifecycleState state) {
    final token = _ref.read(authTokenProvider);
    if (token == null) return;

    final privateWS = _ref.read(privateWebSocketProvider);
    final groupWS = _ref.read(groupWebSocketProvider);

    if (privateWS == null || groupWS == null) return;

    if (state == AppLifecycleState.resumed) {
      privateWS.connect();
      groupWS.connect();
    } else if (state == AppLifecycleState.paused) {
      privateWS.disconnect();
      groupWS.disconnect();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _handleLifecycle(state);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      _ref = ref;
      final token = ref.watch(authTokenProvider);

      // Initial connection after login
      if (token != null) {
        final privateWS = ref.read(privateWebSocketProvider);
        final groupWS = ref.read(groupWebSocketProvider);

        if (privateWS != null && !privateWS.isConnected) {
          privateWS.connect();
        }
        if (groupWS != null && !groupWS.isConnected) {
          groupWS.connect();
        }
      }

      return widget.child;
    });
  }
}
