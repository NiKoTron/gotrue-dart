import 'package:gotrue/src/constants.dart';
import 'package:gotrue/src/session.dart';

typedef Unsubscriber = void Function();
typedef Callback = void Function(AuthChangeEvent event, Session? session);

class Subscription {
  final String id;
  final Callback callback;
  final Unsubscriber unsubscribe;

  const Subscription({
    required this.id,
    required this.callback,
    required this.unsubscribe,
  });
}
