library todo;

import 'dart:html' as dom;
import 'package:angular/angular.dart';

@NgDirective(
	// ng-submit is eventually going to be added, using `todo-` as prefix will
	// avoid future name clashes.
	selector: '[todo-submit]',
	map: const {'todo-submit': '&onSubmit'}
)
@NgDirective(
	selector: '[todo-dblclick]',
	map: const {'todo-dblclick': '&onDblclick'}
)
@NgDirective(
	selector: '[todo-escape]',
	map: const {'todo-escape': '&onEscape'}
)
class TodoDOMEventDirective {
	Map listeners = {};
	final dom.Element element;
	final Scope scope;
	
	static final int ESCAPE_KEY = 27;

	TodoDOMEventDirective(dom.Element this.element, Scope this.scope);

	void initHandler(stream, value, [bool predicate(event)]) {
		final int key = stream.hashCode;
		
		if (!listeners.containsKey(key)) {
			listeners[key] = value;
			stream.listen((event) => scope.$apply(() {
				if (predicate == null || predicate(event)) {
					event.preventDefault();
					value({r"$event": event});
				}
			}));
		}
	}

	set onSubmit(value) => initHandler(element.onSubmit, value);

	set onEscape(value) {
		initHandler(element.onKeyDown, value, (event) => event.keyCode == ESCAPE_KEY);
	}

	set onDblclick(value) => initHandler(element.onDoubleClick, value);
}

@NgDirective(
	// ng-submit is eventually going to be added, using `todo-` as prefix will
	// avoid future name clashes.
	selector: '[todo-focus]',
	map: const {'todo-focus': '@todoFocus'}
)
class TodoFocusDirective {
	Map listeners = {};
	final dom.Element element;
	final Scope scope;

	TodoFocusDirective(dom.Element this.element, Scope this.scope);

	set todoFocus(watchExpr) {
		scope.$watch(watchExpr, (value) {
			if (value) {
				element.focus();
			}
		});
	}
}

class Item {
	String title;
	bool done;
	
	Item([String this.title = '', bool this.done = false]);
	
	bool get isEmpty => title.isEmpty;

	Item clone() => new Item(this.title, this.done);

	String toString() => done ? "[X]" : "[ ]" + " ${this.title}";
}

@NgDirective(
	selector: '[todo-controller]',
	publishAs: 'todo'
)
class TodoController {
	// TODO: Read from localStorage
	List<Item> items = [new Item("wow", false)];
	Item newItem = new Item();
	Item editedItem = null;
	Item previousItem = null;
	
	void add() {
		if (!newItem.isEmpty) {
			items.add(newItem);
			newItem = new Item();
		} else {
			print("Item is empty: " + newItem.title);
		}
	}
	
	void remove(Item item) {
		items.remove(item);
	}
	
	void clearCompleted() {
		items.removeWhere((i) => i.done);
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
	
	bool get allChecked {
		return items.every((i) => i.done);
	}
	
	void set allChecked(value) {
		items.forEach((i) => i.done = value);
	}
	
	String get itemsLeftText {
		return 'item' + (remaining() != 1 ? 's' : '') + ' left';
	}

	void editTodo(Item item) {
		editedItem = item;
		previousItem = item.clone();
	}

	void doneEditing() {
		if (editedItem != null && editedItem.isEmpty) {
			items.remove(editedItem);
		}

		editedItem = null;
		previousItem = null;
	}

	void revertEditing(Item item) {
		editedItem = null;
		item.title = previousItem.title;
		previousItem = null;
	}
}