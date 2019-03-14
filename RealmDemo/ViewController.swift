import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let dataController = DataController()
    var users: Results<User>?
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.users = try! self.dataController.fetchUsers().sorted(byKeyPath: "firstName")
        self.token = self.users?.observe(self.observeChanges)
    }
    
    deinit {
        self.token?.invalidate()
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
    
    private func observeChanges(changes: RealmCollectionChange<Results<User>>) {
        switch changes {
        case .initial:
            tableView.reloadData()
            
        case .update(_, let deletions, let insertions, let modifications):
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
            self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
            self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
            self.tableView.endUpdates()
            
        case .error(let error):
            fatalError("\(error)")
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = self.users![indexPath.row]
        
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
        guard editingStyle == .delete else { return }
        let user = self.users![indexPath.row]
        try? self.dataController.delete(user: user)
    }
}
