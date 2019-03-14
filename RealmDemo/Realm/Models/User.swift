import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var bonusPoints: String = "" // to test migration change to "bonusPoints: Int32 = 0"
    let books = List<Book>()
}
