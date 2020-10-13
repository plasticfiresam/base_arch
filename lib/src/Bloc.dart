import 'dart:async';

import 'Action.dart';
import 'Reducer.dart';
import 'State.dart';

abstract class Bloc<S extends State, A extends Action, R extends Reducer> {
  final _stateController = StreamController<State>.broadcast();
  final _actionsController = StreamController<Action>();

  var _currentState;

  Stream<State> get state => _stateController.stream;
  Sink<Action> get action => _actionsController.sink;
  StateListener _stateListener;

  final Map<Type, R> _reducers;

  Bloc(this._reducers, this._currentState) {
    _actionsController.stream.listen(handleAction);
    _stateListener = (state) {
      _stateController.sink.add(state);
      _currentState = state;
    };

    _stateController.add(_currentState);
  }

  void handleAction(Action action) async {
    _reducers[action.runtimeType]
        ?.call(_currentState, action)
        ?.listen(_stateListener);
  }

  void dispose() {
    _stateController.close();
    _actionsController.close();
  }

  void add(Action action) {
    _actionsController.sink.add(action);
  }
}

typedef void StateListener(State _);
