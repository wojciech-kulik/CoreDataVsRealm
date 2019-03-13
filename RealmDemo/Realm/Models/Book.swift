import Foundation
import RealmSwift

public class Book: Object {
    @objc dynamic public var title: String = ""
    let users: List<User> = List<User>()
    let owners = LinkingObjects(fromType: User.self, property: "books")
}
