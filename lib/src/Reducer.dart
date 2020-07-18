import 'Action.dart';
import 'State.dart';

abstract class Reducer<S extends State, A extends Action> {
  Stream<S> call(S prevState, A action) async* {}
}
