import Foundation
import CoreData

class CustomMigration: NSEntityMigrationPolicy {
    
    @objc func toInt16(value: String) -> NSNumber {
        return NSNumber(value: Int16(value)!)
    }
}
