//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by SHARMA, YOGESH [AG-Contractor/1000] on 4/8/19.
//  Copyright © 2019 SHARMA, YOGESH [AG-Contractor/1000]. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photoId: String?
    @NSManaged public var title: String?
    @NSManaged public var dateTaken: NSDate?
    @NSManaged public var remoteURL: NSURL?

}
