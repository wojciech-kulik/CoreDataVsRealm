import Foundation
import RealmSwift

public class User: Object {
    @objc dynamic public var firstName: String = ""
    @objc dynamic public var lastName: String = ""
    @objc dynamic public var username: String = ""
    @objc dynamic public var bonusPoints: String = ""
    let books = List<Book>()
}
