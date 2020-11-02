import 'dart:async';

import 'Action.dart';
import 'Reducer.dart';
import 'State.dart';

abstract class Bloc<S extends State, A extends Action, R extends Reducer> {
  final _stateController = StreamController<S>.broadcast();
  final _actionsController = StreamController<A>();

  S _currentState;

  Stream<S> get state => _stateController.stream;
  S get currentState => _currentState;
  Sink<A> get action => _actionsController.sink;
  StateListener _stateListener;

  final Map<Type, R> _reducers;

  Bloc(this._reducers, S initialState) {
    _currentState = initialState;
    _actionsController.stream.listen(handleAction);
    _stateListener = (state) {
      _stateController.sink.add(state);
      _currentState = state;
    };

    _stateController.add(_currentState);
  }

  void handleAction(A action) async {
    _reducers[action.runtimeType]
        ?.call(_currentState, action)
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
