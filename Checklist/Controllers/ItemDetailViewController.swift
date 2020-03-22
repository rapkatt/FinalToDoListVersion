
import UIKit
import RealmSwift

 
protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {

  weak var delegate: ItemDetailViewControllerDelegate?
  var todoList: Results<ChecklistItem>!
  weak var itemToEdit: ChecklistItem?
  
  @IBOutlet weak var cancelBarButton: UIBarButtonItem!
  @IBOutlet weak var addBarButton: UIBarButtonItem!
  @IBOutlet weak var textfield: UITextField!
  @IBOutlet weak var textfield2: UITextField!
    
  
  @IBAction func cancel(_ sender: Any) {
    delegate?.itemDetailViewControllerDidCancel(self)
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func done(_ sender: Any) {
    if let item = itemToEdit, let text = textfield.text, let text2 = textfield2.text{
        try! DBManager.sharedInstance.database.write{
        item.text = text
        item.extraText = text2
        }
        delegate?.itemDetailViewController(self, didFinishEditing: item)
    }else{
    let item = ChecklistItem()
      if let textFieldText = textfield.text, let textField2 = textfield2.text {
        item.text = textFieldText
        item.extraText = textField2
      }
        delegate?.itemDetailViewController(self, didFinishAdding: item)
      dismiss(animated: true, completion: nil)
    }
   
    
    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let item = itemToEdit {
      title = "Edit Item"
      textfield.text = item.text
      textfield2.text = item.extraText
      addBarButton.isEnabled = true
    }
    
    navigationItem.largeTitleDisplayMode = .never
    
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    textfield.becomeFirstResponder()
  }
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}

extension ItemDetailViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textfield.resignFirstResponder()
    textfield2.resignFirstResponder()
    return false
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    guard let oldText = textfield.text,
          let stringRange = Range(range, in: oldText) else {
        return false
    }
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    if newText.isEmpty {
      addBarButton.isEnabled = false
    } else {
      addBarButton.isEnabled = true
    }
    return true
  }

}
