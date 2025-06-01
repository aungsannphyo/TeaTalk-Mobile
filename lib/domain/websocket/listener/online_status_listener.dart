import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../online_status_map_provider.dart';
import '../online_status_model.dart';
import '../websocket_provider.dart';

final onlineStatusListenerProvider = Provider<void>((ref) {
  // Listen to private chat status stream
  ref.listen<AsyncValue<OnlineStatusModel?>>(
    privateStatusProvider,
    (previous, next) {
      next.whenData((status) {
        if (status == null) return;
        final currentMap = ref.read(onlineStatusMapProvider);
        final updatedMap = Map<String, bool>.from(currentMap)
          ..[status.userId] = status.status == 1;
        ref.read(onlineStatusMapProvider.notifier).state = updatedMap;
      });
    },
  );

  // Optionally handle group status updates similarly if you support that.
  ref.listen<AsyncValue<OnlineStatusModel?>>(
    groupStatusProvider,
    (previous, next) {
      next.whenData((status) {
        if (status == null) return;
        final currentMap = ref.read(onlineStatusMapProvider);
        final updatedMap = Map<String, bool>.from(currentMap)
          ..[status.userId] = status.status == 1;
        ref.read(onlineStatusMapProvider.notifier).state = updatedMap;
      });
    },
  );
});
