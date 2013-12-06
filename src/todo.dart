library todo;

import 'dart:html' as dom;
import 'dart:convert' as convert;
import 'package:angular/angular.dart';

class Item {
	String title;
	bool done;
	
	Item([String this.title = '', bool this.done = false]);
	
	Item.fromJson(Map obj) {
		this.title = obj["title"];
		this.done = obj["done"];
	}

	bool get isEmpty => title.trim().isEmpty;

	Item clone() => new Item(this.title, this.done);

	String toString() => done ? "[X]" : "[ ]" + " ${this.title}";

	void normalize() {
		this.title = this.title.trim();
	}

	// This is method is called when from JSON.encode.
	Map toJson() => { "title": title, "done": done };
}

@NgDirective(
	selector: '[todo-controller]',
	publishAs: 'todo'
)
class TodoController {
	List<Item> items = [];
	Item newItem = new Item();
	Item editedItem = null;
	Item previousItem = null;
	
	static const String STORAGE_KEY = "todomvc_dartangular";

	TodoController(Scope scope) {
		// TODO: Should be a service, seperate class or something like that.
		final String data = dom.window.localStorage[STORAGE_KEY];
		print("data: $data");
		if (data != null) {
			List<Map> rawItems = convert.JSON.decode(data);
			this.items = rawItems.map((item) => new Item.fromJson(item)).toList();
		}

		scope.$watchCollection('todo.items', (c) {
			var enc = convert.JSON.encode(c);
			dom.window.localStorage[STORAGE_KEY] = convert.JSON.encode(c);
		});
	}

	void add() {
		if (!newItem.isEmpty) {
			newItem.normalize();
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
		if (editedItem == null) {
			return;
		}

		if (editedItem.isEmpty) {
			items.remove(editedItem);
		}

		editedItem.normalize();
		editedItem = null;
		previousItem = null;
	}

	void revertEditing(Item item) {
		editedItem = null;
		item.title = previousItem.title;
		previousItem = null;
	}
}