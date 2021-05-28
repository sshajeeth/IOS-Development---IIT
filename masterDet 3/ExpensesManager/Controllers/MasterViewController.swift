

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet var categoryTable: UITableView!
    
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        navigationItem.leftBarButtonItem = editButtonItem

//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton
//        if let split = splitViewController {
//            let controllers = split.viewControllers
//            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
        
        let nibName = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "categoryCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        autoSelectTableRow()
    }

    func autoSelectTableRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        if tableView.hasRowAtIndexPath(indexPath: indexPath as NSIndexPath) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = fetchedResultsController.object(at: indexPath)
                self.performSegue(withIdentifier: "showDetail", sender: object)
            }
        } else {
            let empty = {}
            self.performSegue(withIdentifier: "showDetail", sender: empty)
        }
    }

//    @objc
//    func insertNewObject(_ sender: Any) {
//        let context = self.fetchedResultsController.managedObjectContext
//        let newEvent = Event(context: context)
//             
//        // If appropriate, configure the new managed object.
//        newEvent.name = Date()
//
//        // Save the context.
//        do {
//            try context.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
            self.performSegue(withIdentifier: "showDetail", sender: object)
        }
    }
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.detailItem = object as ExpensesCategory?
//                print("Shajeeth\(object)")
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//                detailViewController = controller
            }
        }
        
        if segue.identifier == "addCategory" {
            if let controller = segue.destination as? UIViewController {
                controller.popoverPresentationController!.delegate = self
            }
        }
        
        if segue.identifier == "editCategory" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! AddEditCategoryViewController
                controller.editingCategory = object as ExpensesCategory
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let event = fetchedResultsController.object(at: indexPath)
//        configureCell(cell as! CategoryTableViewCell, withEvent: event)
        configureCell(cell as! CategoryTableViewCell, withEvent: event)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func configureCell(_ cell: CategoryTableViewCell, withEvent event: ExpensesCategory) {
//        cell.textLabel!.text = event.name
        cell.commonInit(event.name!, categoryBudget: Double(event.budget), categoryNotes: event.notes!)
        cell.backgroundColor = UIColor(hexString: event.color ?? "#FFFFFF")
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<ExpensesCategory> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<ExpensesCategory> = ExpensesCategory.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController<ExpensesCategory>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                configureCell(tableView.cellForRow(at: indexPath!)! as! CategoryTableViewCell, withEvent: anObject as! ExpensesCategory)
            case .move:
                configureCell(tableView.cellForRow(at: indexPath!)! as! CategoryTableViewCell, withEvent: anObject as! ExpensesCategory)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
            default:
                return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func showPopoverFrom(cell: CategoryTableViewCell, forButton button: UIButton, forNotes notes: String) {
        let buttonFrame = button.frame
        var showRect = cell.convert(buttonFrame, to: categoryTable)
        showRect = categoryTable.convert(showRect, to: view)
        showRect.origin.y -= 5
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "NotesPopoverController") as? NotesPopoverController
        controller?.modalPresentationStyle = .popover
        controller?.preferredContentSize = CGSize(width: 300, height: 250)
        controller?.notes = notes
        
        if let popoverPresentationController = controller?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = showRect
            
            if let popoverController = controller {
                present(popoverController, animated: true, completion: nil)
            }
        }
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         tableView.reloadData()
     }
     */

}
extension MasterViewController: CategoryTableViewCellDelegate {
    func customCell(cell: CategoryTableViewCell, sender button: UIButton, data: String) {
        self.showPopoverFrom(cell: cell, forButton: button, forNotes: data)
    }
}



