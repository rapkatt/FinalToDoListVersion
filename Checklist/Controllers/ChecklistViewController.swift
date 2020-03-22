

import UIKit
import RealmSwift

class ChecklistViewController: UITableViewController{
    
    var searchList: [ChecklistItem] = []
    var searching = false
    var item: ChecklistItem?
    var todoList: Results<ChecklistItem>!
    @IBAction func addItem(_ sender: Any) {
        performSegue(withIdentifier: "AddItemSegue", sender: nil)
    }
    @IBOutlet var menuButton:UIBarButtonItem!
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tbView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideBarFunction()
        tableView.reloadData()
        
    }
    
    func sideBarFunction(){
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        if let todos: Results<ChecklistItem> = DBManager.sharedInstance.getDataFromDB(){
            todoList = todos
        }
    }
       
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchList.count
        }else{
            return todoList.count
        }
    
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        if searching {
            cell.textLabel?.text = searchList[indexPath.row].text
            let item = searchList[indexPath.row]
            
            if item.checked {
                cell.imageView?.image = UIImage(named: "image")
            }else{
                cell.imageView?.image = UIImage(named: "")
            }
            configureText(for: cell, with: item)
        }else{
            let item = todoList[indexPath.row]
            
            if item.checked {
                cell.imageView?.image = UIImage(named: "image")
            }else{
                cell.imageView?.image = UIImage(named: "")
            }
            configureText(for: cell, with: item)
        }
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            item = searchList[indexPath.row]
        }else{
            item = todoList[indexPath.row]
        }
        try! DBManager.sharedInstance.database.write{
            item!.toggleChecked()
        }
        
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        DBManager.sharedInstance.deleteFromDb(object: todoList[indexPath.row])
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if searching {
            item = searchList[indexPath.row]
        }else{
            item = todoList[indexPath.row]
        }
        performSegue(withIdentifier: "EditItemSegue", sender: nil)
    }
    

    
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        cell.textLabel?.text = item.text
        cell.detailTextLabel?.text = item.extraText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                itemDetailViewController.delegate = self
                itemDetailViewController.todoList = todoList
            }
        } else if segue.identifier == "EditItemSegue" {
            if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                    itemDetailViewController.itemToEdit = item
                   itemDetailViewController.delegate = self
            }
        }
    }
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
        
    }

    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        DBManager.sharedInstance.addData(object: item)
        tableView.reloadData()

    }


    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        
        if let index = todoList.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }

}
extension ChecklistViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchList = todoList.filter({$0.text.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
}

