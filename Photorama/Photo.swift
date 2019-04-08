import Foundation

class Photo {
    let title: String
    let photoId: String
    let remoteURL: URL
    let dateTaken: Date
    
    init(title: String, photoId: String, remoteURL: URL, dateTaken: Date ) {
        self.title = title
        self.photoId = photoId
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}

extension Photo : Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoId == rhs.photoId
    }
}
