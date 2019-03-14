import Foundation
import RealmSwift

class Book: Object {
    @objc dynamic var title: String = ""
    let owners = LinkingObjects(fromType: User.self, property: "books")
}
