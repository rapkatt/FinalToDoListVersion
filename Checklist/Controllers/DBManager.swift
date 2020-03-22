
import UIKit
import RealmSwift

class DBManager {

    var database: Realm
    static let sharedInstance = DBManager()
    
    private init() {
        database = try! Realm()
    }
    
    func getDataFromDB() -> Results<ChecklistItem> {
        let results: Results<ChecklistItem> = database.objects(ChecklistItem.self)
        return results
    }
    
    func addData(object: ChecklistItem)   {
        try! database.write {
            database.add(object)
            print("Added new object")
        }
    }
    
    func deleteFromDb(object: ChecklistItem)   {
        try!   database.write {
            database.delete(object)
        }
    }
}

    
