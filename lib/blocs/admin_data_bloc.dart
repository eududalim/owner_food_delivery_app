import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class AdminDataBloc extends BlocBase {
  @override
  void dispose() {
    _dataController.close();
  }

  final _dataController = BehaviorSubject<Map<String, dynamic>>();

  Stream<Map> get outdata => _dataController.stream;
}
