//
//  ReceiptStore.swift
//  PACReceipts
//
//  Created by kent daniel on 10/9/2023.
//

import UIKit
import CoreData

class ReceiptStore: NSObject {
    let persistentContainer: NSPersistentContainer = {
        // creates the NSPersistentContainer object
        // must be given the name of the Core Data model file “LoanedItems”
        let container = NSPersistentContainer(name: "ReceiptModel")
        
        // load the saved database if it exists, creates it if it does not, and returns an error under failure conditions
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        
        return container
    }()
    
    override init() {
        ValueTransformer.setValueTransformer(UIImageTransformer()
                                             , forName: NSValueTransformerName("UIImageTransformer"))
    }
    
    private func saveContext() {
        let viewContext = persistentContainer.viewContext
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func createReceipt(name:String , category:String , total: Float , image: UIImage , isTaxDeductible: Bool , date: Date ){
        let receiptEntity = NSEntityDescription.entity(forEntityName: "Receipt", in: persistentContainer.viewContext)!
        let receipt = NSManagedObject(entity: receiptEntity, insertInto: persistentContainer.viewContext)
        receipt.setValue(name, forKeyPath: "name")
        receipt.setValue(date, forKeyPath: "date")
        receipt.setValue(image, forKeyPath: "image")
        receipt.setValue(category, forKey: "category")
        receipt.setValue(isTaxDeductible, forKeyPath: "isTaxDeductible")
        receipt.setValue(total, forKeyPath: "total")
        saveContext()
    }
    
    func fetchAllReceipts(completion: @escaping ([Receipt]?) -> Void) {
        
        let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        let viewContext = persistentContainer.viewContext
        
        do {
            let allItems = try viewContext.fetch(fetchRequest)
            completion(allItems)
        } catch {
            completion(nil)
        }
    }
    
    // MARK: Home Page & Receipts Page
    func fetchReceiptsGroupedByMonth(completion: @escaping ([String: [Receipt]]?) -> Void) {
        let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        let viewContext = persistentContainer.viewContext
        
        do {
            let allItems = try viewContext.fetch(fetchRequest)
            
            // Create a dictionary to store receipts grouped by month
            var groupedReceipts: [String: [Receipt]] = [:]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM" // Customize the date format as needed
            
            for receipt in allItems {
                
                let monthKey = dateFormatter.string(from: receipt.date)
                
                if var receiptsForMonth = groupedReceipts[monthKey] {
                    receiptsForMonth.append(receipt)
                    groupedReceipts[monthKey] = receiptsForMonth
                } else {
                    groupedReceipts[monthKey] = [receipt]
                }
                
            }
            
            completion(groupedReceipts)
        } catch {
            completion(nil)
        }
    }
    
    // MARK: receipts page
    func fetchReceipts(withCategory category: String, completion: @escaping ([Receipt]?) -> Void) {
        let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        let viewContext = persistentContainer.viewContext
        
        // Create a predicate to filter by category
        let categoryPredicate = NSPredicate(format: "category == %@", category)
        fetchRequest.predicate = categoryPredicate
        
        do {
            let filteredReceipts = try viewContext.fetch(fetchRequest)
            completion(filteredReceipts)
        } catch {
            completion(nil)
        }
    }

    
    // MARK: Tax Page
    func fetchReceipts(inDateRange startDate: Date, endDate: Date, completion: @escaping ([Receipt]?) -> Void) {
        let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        let viewContext = persistentContainer.viewContext
        
        // Set a predicate to filter receipts within the date range
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as CVarArg, endDate as CVarArg)
        
        do {
            let filteredReceipts = try viewContext.fetch(fetchRequest)
            completion(filteredReceipts)
        } catch {
            completion(nil)
        }
    }

    
}
