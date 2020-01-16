import 'package:equatable/equatable.dart';
import 'package:prayer_bloc/models/Options.dart';

abstract class OptionsEvent extends Equatable {
  const OptionsEvent();

}
class FetchOptionsEvent extends OptionsEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class SaveOptionsEvent extends OptionsEvent {
  Options options;


  SaveOptionsEvent(this.options);

  @override
  // TODO: implement props
  List<Object> get props => null;
}