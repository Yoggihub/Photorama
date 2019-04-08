import UIKit

class ImageStore {
    
    var photo = [Item]()
    
    
    init(){
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path){
        photo = archivedItems
        }
    }
    @discardableResult func createPhoto() -> Photo {
        let newPhoto = Item(random: true)
        photo.append()
    }
    
    
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory =  documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.archive")
    }()
}
