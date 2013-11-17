library todo;

import 'package:angular/angular.dart';

class Item {
	String title;
	bool done;
	
	Item([String this.title = '', bool this.done = false]);
	
	bool get isEmpty => title.isEmpty;
}

@NgDirective(
	selector: '[todo-controller]',
	publishAs: 'todo'
)
class TodoController {
	// TODO: Read from localStorage
	List<Item> items = [];
	
	int remaining() {
		return items.where((item) => !item.done).length;
	}
	
	int completed() {
		return items.where((item) => item.done).length;
	}
	
	int total() {
		return items.length;
	}
}