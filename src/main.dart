import 'package:di/di.dart';
import 'package:angular/angular.dart';

import 'todo.dart';

main() {
	print('Booting TodoMVC. Stand back!');

	var module = new Module()
		..type(TodoController);

	ngBootstrap(module: module);
}
