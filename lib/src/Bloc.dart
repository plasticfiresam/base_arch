import 'dart:async';

import 'Action.dart';
import 'Reducer.dart';
import 'State.dart';

abstract class Bloc<S extends State, A extends Action, R extends Reducer> {
  final _stateController = StreamController<S>.broadcast();
  final _actionsController = StreamController<A>();

  S currentState;

  Stream<State> get state => _stateController.stream;
  Sink<Action> get action => _actionsController.sink;
  StateListener _stateListener;

  final Map<Type, R> _reducers;

  Bloc(this._reducers, S initialState) {
    currentState = initialState;
    _actionsController.stream.listen(handleAction);
    _stateListener = (state) {
      _stateController.sink.add(state);
      currentState = state;
    };

    _stateController.add(currentState);
  }

  void handleAction(A action) async {
    _reducers[action.runtimeType]
        ?.call(currentState, action)
        ?.listen(_stateListener);
  }

  void dispose() {
    _stateController.close();
    _actionsController.close();
  }

  void add(A action) {
    _actionsController.sink.add(action);
  }
}

typedef void StateListener(State _);
