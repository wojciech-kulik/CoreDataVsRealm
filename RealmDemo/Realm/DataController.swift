import Foundation
import RealmSwift

class DataController {
    let realm = try! Realm(configuration:
        Realm.Configuration(fileURL: FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("database"), schemaVersion: 1))
    
    func fetchUsers() throws -> [User] {
        let users = self.realm.objects(User.self).sorted { $0.firstName.lowercased() < $1.firstName.lowercased() }
        return Array(users)
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
            self.realm.delete(user)
        }
    }
    
    func deleteUsers(withName name: String) throws {
        let users = try self.fetchUsers(withName: name)
        
        try self.realm.write {
            self.realm.delete(users)
        }
    }
}
