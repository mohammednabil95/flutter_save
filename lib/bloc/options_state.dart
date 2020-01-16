import 'package:equatable/equatable.dart';
import 'package:prayer_bloc/models/Options.dart';
import 'package:meta/meta.dart';

abstract class OptionsState extends Equatable {
  const OptionsState();
}

class InitialOptionsState extends OptionsState {
  @override
  List<Object> get props => [];
}

class OptionsLoadedState extends OptionsState {

  Options options;

  OptionsLoadedState({@required this.options});

  @override
  // TODO: implement props
  List<Object> get props => [options];
}
