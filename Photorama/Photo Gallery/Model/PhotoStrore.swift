import Foundation
import UIKit
import CoreData


enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

enum TagsResult {
    case success([Tag])
    case failure(Error)
}

class PhotoStore {
    
    let imageStore = ImageStore()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Photorama")
        container.loadPersistentStores{ (description, error) in
            if let error = error {
                print("error setting up core data (\(error))")
            }
        }
        return container
    }()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        let url =  FlickrAPI.interestingPhotoURL
        print("This is a URL: \(url)")
        
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            var result = self.processPhotosRequest(data: data, error: error)
            
            if case .success = result {
                do {
                    try self.persistentContainer.viewContext.save()
                } catch let error {
                    result = .failure(error)
                }
            }
            //Run the proceess on the main thread
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData, into: persistentContainer.viewContext)
    }
    
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        
        guard let photoKey = photo.photoId else {
            preconditionFailure("Phot expected to have a photo Id")
        }
        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        guard let photoUrl = photo.remoteURL else {
            preconditionFailure("Phot expected to have a remote URL")
        }
        let request = URLRequest(url: photoUrl as URL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard
            let imageData = data,
            let image =  UIImage(data: imageData)
        else {
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(error!)
            }
        }
        return .success(image)
    }
    
    func fetchAllPhotos(completion: @escaping(PhotosResult) -> Void) {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortByDateTaken = NSSortDescriptor(key: #keyPath(Photo.dateTaken), ascending: true)
        fetchRequest.sortDescriptors = [sortByDateTaken]
        
        let viewContext =  persistentContainer.viewContext
        viewContext.perform {
            do {
            let allPhotos = try viewContext.fetch(fetchRequest)
            completion(.success(allPhotos))
        } catch {
            completion(.failure(error))
        }
    }
  }
    
    func fetchAllTags(completion: @escaping(TagsResult) -> Void) {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Tag.name), ascending: true)
        fetchRequest.sortDescriptors = [sortByName]
        
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do {
                let alltags = try fetchRequest.execute()
                completion(.success(alltags))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
