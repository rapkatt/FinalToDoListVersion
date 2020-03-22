

import Foundation
import RealmSwift

class ChecklistItem:Object{

   @objc dynamic  var text = ""
   @objc dynamic  var extraText = ""
   @objc dynamic var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
    var todos: [ChecklistItem] = []
    
    func newTodo() -> ChecklistItem {
      let item = ChecklistItem()
      todos.append(item)
      item.checked = false
      return item
    }
//    :NSObject, NSCoding {
//    init(text: String = "", extraText: String = "", checked: Bool = false) {
//        self.text = text
//        self.extraText = extraText
//        self.checked = checked
//    }
//
//    func encode(with coder: NSCoder) {
//        coder.encode(self.text, forKey: "text")
//        coder.encode(self.extraText, forKey: "extraText")
//        coder.encode(checked, forKey: "checked")
//    }
//
//
//    init(json: [String: Any]) {
//        self.text = json["text"] as? String
//        self.checked = json["checked"] as? Bool
//        self.extraText = json["extraText"] as? String
//    }
//
//
//    required init?(coder aDecoder: NSCoder)
//    {
//        self.text = aDecoder.decodeObject(forKey: "text") as? String
//        self.checked = aDecoder.decodeObject(forKey: "checked") as? Bool
//        self.extraText = aDecoder.decodeObject(forKey: "extraText") as? String
//    }

}


