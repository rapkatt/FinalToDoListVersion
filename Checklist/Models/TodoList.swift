

import Foundation
import RealmSwift

class TodoList: Object {
  
  
  
  var todos: [ChecklistItem] = []
  
  func newTodo() -> ChecklistItem {
    let item = ChecklistItem()
    todos.append(item)
    item.checked = false
    return item
  }

}
