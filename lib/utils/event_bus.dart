import 'package:event_bus/event_bus.dart';

class EventBusUtil {
  static final EventBus _eventBus = EventBus();

  static EventBus getInstance() {
    return _eventBus;
  }


}

class VideoPauseEvent {}

class LoginSuccessEvent{}

class UseCouponEvent{
  String id;
  UseCouponEvent(this.id);
}

class TabChangeEvent {
  int index;

  TabChangeEvent(this.index);
}

class HomeGuideStep2{}


