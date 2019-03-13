import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let dataController = DataController()
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.refresh()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "New User", message: "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            let user = User()
            user.firstName = alertController.textFields?[0].text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
            user.lastName = alertController.textFields?[1].text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
            user.username = alertController.textFields?[2].text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
            user.bonusPoints = "10"
            
            try? self.dataController.insert(user: user, withBook: true)
            self.users.append(user)
            self.users.sort(by: { $0.firstName.lowercased() < $1.firstName.lowercased() })
            
            let newIndex = self.users.firstIndex(of: user) ?? 0
            self.tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .automatic)
        })
        
        alertController.addTextField { textField in
            textField.placeholder = "First name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Last name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Username"
        }
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    private func refresh() {
        self.users = (try? self.dataController.fetchUsers()) ?? []
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = self.users[indexPath.row]
        
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        cell.detailTextLabel?.text = user.username
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let user = self.users[indexPath.row]
            try? self.dataController.delete(user: user)
            
            self.users.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
