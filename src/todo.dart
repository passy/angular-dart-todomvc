library todo;

import 'dart:html' as dom;
import 'package:angular/angular.dart';

@NgDirective(
	// ng-submit will eventually be added, using `todo-` as prefix will avoid
	// future name clashes
	selector: '[todo-submit]',
	map: const {'ng-submit': '&onSubmit'}
)
class TodoSubmitDirective {
	var listeners = {};
	dom.Element element;
	Scope scope;
	TodoSubmitDirective(dom.Element this.element, Scope this.scope);
	
	set onSubmit(value) {
		var stream = element.onSubmit;
		int key = stream.hashCode;
		print("registering submit handler for " + value);
		if (!listeners.containsKey(key)) {
			listeners[key] = value;
			stream.listen((event) => scope.$apply(() {
				value({r"$event": event});
			}));
		}
	}
}

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
	List<Item> items = [new Item("wow", false)];
	Item newItem = new Item();
	
	void add() {
		if (!newItem.isEmpty) {
			items.add(newItem);
			newItem = new Item();
		}
	}
	
	int remaining() {
		return items.where((item) => !item.done).length;
	}
	
	int completed() {
		return items.where((item) => item.done).length;
	}
	
	int total() {
		return items.length;
	}
	
	String get itemsLeftText {
		return 'item' + (remaining() != 1 ? 's' : '') + ' left';
	}
}