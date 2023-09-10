//
//  Receipt+CoreDataProperties.swift
//  
//
//  Created by kent daniel on 10/9/2023.
//
//

import Foundation
import CoreData
import UIKit

extension Receipt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receipt> {
        return NSFetchRequest<Receipt>(entityName: "Receipt")
    }

    @NSManaged public var image: UIImage
    @NSManaged public var name: String?
    @NSManaged public var category: String
    @NSManaged public var total: Float
    @NSManaged public var isTaxDeductible: Bool
    @NSManaged public var date: Date

}
