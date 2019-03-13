import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let dataController = DataController()
    var fetchController: NSFetchedResultsController<User>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.dataController.initalizeStack {
            _ = try? self.dataController.fetchUsers()
            let request = User.fetchRequest() as NSFetchRequest<User>
            request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
            
            let fetchController = NSFetchedResultsController(fetchRequest: request,
                                                             managedObjectContext: self.dataController.context,
                                                             sectionNameKeyPath: nil, cacheName: nil)

            fetchController.delegate = self
            self.fetchController = fetchController
            try? fetchController.performFetch()
        }
    }
    
    @IBAction func addClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "New User", message: "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            let user = User(context: self.dataController.context)
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
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete: self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .insert: self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update: self.tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move: self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let user = self.fetchController?.object(at: indexPath) else { return cell }
        
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
            guard let user = self.fetchController?.object(at: indexPath) else { return }
            try? self.dataController.delete(user: user)
        }
    }
}
