import UIKit
import CoreData

class ViewController: UIViewController {

    let dataController = DataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataController.initalizeStack()
    }
}
