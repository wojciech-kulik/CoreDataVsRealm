import Foundation
import RealmSwift

class DataController {
    var realm: Realm
    static let currentVersion: UInt64 = 1
    
    init() {
        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("database.realm")
        print(url.absoluteString)
        
        Realm.Configuration.defaultConfiguration =
            Realm.Configuration(fileURL: url, schemaVersion: DataController.currentVersion, migrationBlock: DataController.migrate)
        
        self.realm = try! Realm()
    }
    
    func fetchUsers() throws -> Results<User> {
        let users = self.realm.objects(User.self)
        return users
    }
    
    func fetchUsers(withName name: String) throws -> [User] {
        let users = self.realm.objects(User.self).filter("firstName == %@", name)
        return Array(users)
    }
    
    func insert(user: User, withBook: Bool) throws {
        if withBook {
            let book = Book()
            book.title = "A Song of Ice and Fire"
            user.books.append(book)
        }
        
        try self.realm.write {
            self.realm.add(user)
        }
    }
    
    func update(user: User) throws {
        try self.realm.write {
            user.firstName = "Jack"
        }
    }
    
    func delete(user: User) throws {
        try self.realm.write {
            user.books.forEach(self.realm.delete)
            self.realm.delete(user)
        }
    }
    
    func deleteUsers(withName name: String) throws {
        let users = try self.fetchUsers(withName: name)
        
        try self.realm.write {
            users.forEach { $0.books.forEach(self.realm.delete) }
            self.realm.delete(users)
        }
    }
    
    static private func migrate(migration: Migration, oldSchemaVersion: UInt64) {
        guard DataController.currentVersion == 2 && oldSchemaVersion == 1 else { return }
        
        migration.enumerateObjects(ofType: User.className()) { oldObject, newObject in
            let oldValue = oldObject!["bonusPoints"] as! String
            newObject!["bonusPoints"] = Int32(oldValue)!
        }
    }
}
