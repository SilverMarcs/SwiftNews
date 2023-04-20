//This Swift file defines a DataStore protocol and an implementation of that protocol called PlistDataStore.
//
//The DataStore protocol defines two methods: save and load. These methods are used for persisting and retrieving a certain type of data represented by the associated type D. It is also an Actor, which means it can safely manage concurrent access to data across multiple threads.
//
//The PlistDataStore class is a concrete implementation of the DataStore protocol for storing and retrieving data from a binary property list format (.plist file). It takes a generic type parameter T, which should conform to the Codable protocol and the Equatable protocol.
//
//The PlistDataStore class has a saved property of the generic type T, where the current saved data is stored. It also has a filename property which is a String that represents the name of the .plist file used to save the data.
//
//The init(filename:) method takes a filename string parameter and sets the corresponding dataURL private property to that filename. This dataURL property is a URL that specifies the directory where the .plist file is saved.
//
//The save(_:) method saves the current data to the .plist file if the saved property is different from the new current data and there are no errors during the encoding or writing process. First, it encodes the current data using a PropertyListEncoder and writes the data to the specified dataURL with an .atomic write strategy. If there are no errors, updates the saved property to reflect the current data.
//
//The load() method retrieves the saved data from the .plist file specified by the dataURL property. If successful, it returns the saved data as a T object. To do this, it first loads the contents of the .plist file as Data and then decodes the Data into a T object using a PropertyListDecoder. Finally, it updates the saved property to reflect the current data.
//
//Overall, this Swift file represents a convenient way to save and retrieve Codable data in a binary property list format using the DataStore protocol and a concrete implementation called PlistDataStore.
                                                                    
import Foundation

// Actor model is good
protocol DataStore: Actor {
    associatedtype D
    
    func save(_ current: D)
    func load() -> D?
    
}

actor PlistDataStore<T: Codable>: DataStore where T: Equatable {
    
    var saved: T?
    let filename: String
    
    init(filename: String) {
        self.filename = filename
    }
    
    // setting filenae for plist file where we save our data
    private var dataURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(filename).plist")
    }
    
    func save(_ current: T) {
        if let saved = self.saved, saved == current {
            return
        }
        
        do {
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .binary
            let data = try encoder.encode(current)
            try data.write(to: dataURL, options: [.atomic])
            self.saved = current
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func load() -> T? {
        do {
            let data = try Data(contentsOf: dataURL)
            let decoder = PropertyListDecoder()
            let current = try decoder.decode(T.self, from: data)
            self.saved = current
            return current
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
