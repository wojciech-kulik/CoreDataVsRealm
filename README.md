# Core Data vs Realm

Sample usage of Core Data, includes:
- populating `UITableView` using `NSFetchedResultsController`
- Data Model in 2 versions
- CRUD operations
- batch request
- heavyweight migration Mapping Model
- strongly typed relationship created by subclassing `NSManagedObject`
- switching between different store types: `NSInMemoryStoreType`, `NSSQLiteStoreType`, `NSBinaryStoreType`

Sample usage of Realm, includes:
- populating `UITableView`
- tracking changes using Realm notifications
- CRUD operations
- batch request
- migration
- strongly typed relationships

To run Realm example, first download dependencies using Carthage: `carthage update`

You can read more about Core Data and Realm in my article:  
https://wojciechkulik.pl/ios/getting-started-with-core-data-using-swift-4
