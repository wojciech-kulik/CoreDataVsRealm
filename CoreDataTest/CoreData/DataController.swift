import Foundation
import CoreData

class DataController {
    let persistentContainer = NSPersistentContainer(name: "LibraryDataModel")
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func initalizeStack() {
        self.persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("could not load store \(error.localizedDescription)")
                return
            }
            print("store loaded")
            
            do {
                try self.insertUser(withBook: true)
                let users = try self.fetchUsers()
                users.forEach {
                    print([$0.firstName, $0.lastName, "\($0.bonusPoints)",
                        $0.books.first?.title ?? ""].joined(separator: ", "))
                }
            } catch (let error) {
                print("failed \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUsers() throws -> [User] {
        let users = try self.context.fetch(User.fetchRequest() as NSFetchRequest<User>)
        return users
    }

    func fetchUsers(withName name: String) throws -> [User] {
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "firstName == %@", name)
        
        let users = try self.context.fetch(request)
        return users
    }
    
    func insertUser(withBook: Bool) throws {
        let user = User(context: self.context)
        user.firstName = "John"
        user.lastName = "Snow"
        user.username = "john_snow12"
        user.bonusPoints = "10"
        
        if withBook {
            let book = Book(context: self.context)
            book.title = "Lord of the Rings"
            user.addToBooks(book)
        }
        
        self.context.insert(user)
        try self.context.save()
    }

    func update(user: User) throws {
        user.firstName = "Jack"
        try self.context.save()
    }
    
    func delete(user: User) throws {
        self.context.delete(user)
        try self.context.save()
    }
    
    func deleteUsers(withName name: String) throws {
        let fetchRequest = User.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        fetchRequest.predicate = NSPredicate(format: "firstName == %@", name)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try self.context.execute(deleteRequest)
        try self.context.save()
    }
}
