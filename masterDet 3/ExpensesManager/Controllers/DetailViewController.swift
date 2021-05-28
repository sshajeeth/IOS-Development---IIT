

import UIKit
import CoreData
import Charts

class DetailViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITableViewDelegate, UIPopoverPresentationControllerDelegate{
  
    
    
    
    
    @IBOutlet var expensesTable: UITableView!
    @IBOutlet var progressBar: CircularProgressBarView!
    @IBOutlet var pieChart: PieChartView!
    @IBOutlet var category_name_lbl: UILabel!
    @IBOutlet var budget_lbl: UILabel!
    @IBOutlet var amount_lbl: UILabel!
    @IBOutlet var remaining_lbl: UILabel!
    @IBOutlet var editBtn: UIBarButtonItem!
    
    let calculations: Calculation = Calculation()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var detailItem: ExpensesCategory?
//        didSet{
//            configureView()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
//        expensesTable.dataSource = self
        let nibName = UINib(nibName: "ExpenseTableViewCell", bundle: nil)
        expensesTable.register(nibName, forCellReuseIdentifier: "expenseCell")
        self.configureView()
        self.setupPieChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the default selected row
        let indexPath = IndexPath(row: 0, section: 0)
        if expensesTable.hasRowAtIndexPath(indexPath: indexPath as NSIndexPath) {
            expensesTable.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        }
        
    }
    
    func configureView() {
        if let category = detailItem{
            
                let expenses = (category.expenses!.allObjects as! [Expenses])

                let totalExpenses = calculations.calculate_total_expenses(expenses)
                progressBar.trackColor = UIColor(hexString: "#e3e3e3")
//                            print(categoryColor)
                progressBar.progressColor = UIColor(hexString: (category.color)!)
                progressBar.setProgressWithAnimation(progress: (totalExpenses/Float(category.budget))*1.0)

                category_name_lbl.text = category.name
                budget_lbl.text = String(category.budget)
                amount_lbl.text = String(totalExpenses)
                var remaining = category.budget-Double(totalExpenses)

                if remaining<0{
                    remaining_lbl.text = String(remaining)
                    remaining_lbl.textColor = UIColor(hexString: "#d9170d")
                } else if remaining>0{
                    remaining_lbl.text = String(remaining)
                    remaining_lbl.textColor = UIColor(hexString: "#47cc04")
                }else {
                    remaining_lbl.text = String(remaining)
                    remaining_lbl.textColor = UIColor(hexString: "#0483cc")
//                }
            }
            setupPieChart()
            expensesTable.reloadData()
            
            
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier{
            case "addExpense":
                if let category = self.detailItem{
                    let destVC = (segue.destination as! UINavigationController).topViewController as! AddEditExpenseViewController
                    destVC.detailItem = category
                }
                
            case "editExpense":
                if let indexPath = expensesTable.indexPathForSelectedRow {
                    let object = _fetchedResultsController!.object(at: indexPath)
                    let controller = (segue.destination as! UINavigationController).topViewController as! AddEditExpenseViewController
                    controller.editingExpense = object as Expenses
                    controller.detailItem = detailItem
                }
            default:
                break
            }
        }
    }
    
    
//    MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        if sectionInfo.numberOfObjects == 0 {
            editBtn.isEnabled = false
            expensesTable.setEmptyMessage("No Expenses Available for this Category.", UIColor.black)
        }
        
        return sectionInfo.numberOfObjects
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as! ExpenseTableViewCell
        configureCell(cell, indexPath: indexPath)
        cell.cellDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    MARK: - Cell Configurations
    func configureCell(_ cell: ExpenseTableViewCell, indexPath: IndexPath) {
        if(self.detailItem != nil){
            let name = (self.fetchedResultsController.fetchedObjects?[indexPath.row].name)!
            let expense = (self.fetchedResultsController.fetchedObjects?[indexPath.row].amount)!
            let date = self.fetchedResultsController.fetchedObjects?[indexPath.row].date
            let reminder = self.fetchedResultsController.fetchedObjects?[indexPath.row].reminder
            let occurance = self.fetchedResultsController.fetchedObjects?[indexPath.row].ocurance
            let notes = self.fetchedResultsController.fetchedObjects?[indexPath.row].notes
            let categoryBudget = (self.detailItem?.budget)!
            let color = self.detailItem?.color
            cell.commonInit1(name, expenseAmount: Double(expense), expense_date: date!, expense_reminder: reminder!, occurance: occurance!, categoryBudget: Double(categoryBudget),color: color!, notes:notes!)
            
        }
    }
    
    
    
    
    
    
    //    MARK: - Fetched results controller
    
    var _fetchedResultsController: NSFetchedResultsController<Expenses>? = nil
     
    var fetchedResultsController: NSFetchedResultsController<Expenses> {
        if _fetchedResultsController != nil{
            return _fetchedResultsController!
        }
//        build the fetch request
        let fetchRequest: NSFetchRequest<Expenses> = Expenses.fetchRequest()
        
//        add a sort descriptor
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        
//        add the sort to request
        fetchRequest.sortDescriptors = [sortDescriptor]
        
//        add the predicate
        if detailItem != nil{
        let predicate = NSPredicate(format: "category = %@", self.detailItem!)
        fetchRequest.predicate = predicate
        }
        
//        intatiate the results
        let aFetchedResultsController = NSFetchedResultsController<Expenses>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: #keyPath(Expenses.expense_category), cacheName: nil)
        
//        set the delegate
        aFetchedResultsController.delegate = self
        
        _fetchedResultsController = aFetchedResultsController
        
//        perform fetch
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return _fetchedResultsController!
    }
    

    
//    MARK: - Table Editing - fetch controller delegate functions
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        expensesTable.beginUpdates()
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        expensesTable.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType){
        switch type {
        case .insert:
            expensesTable.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            expensesTable.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch type {
        case .insert:
            expensesTable.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            expensesTable.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            configureCell(expensesTable.cellForRow(at: indexPath!) as! ExpenseTableViewCell, indexPath: newIndexPath!)
            expensesTable.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            configureCell(expensesTable.cellForRow(at: indexPath!) as! ExpenseTableViewCell, indexPath: newIndexPath!)
        }
        configureView()
        
    }
    
    
    
    
    
    func setupPieChart(){
        pieChart.chartDescription!.enabled = false
        pieChart.drawHoleEnabled = false
        pieChart.rotationAngle = 0
        //        pieChart.rotationEnabled = false
        pieChart.isUserInteractionEnabled = false
        pieChart.legend.enabled = true
        pieChart.legend.horizontalAlignment = .center
//        pieChart.legend.orientation = .vertical
        
        if let category = detailItem{
            let expenses = (category.expenses!.allObjects as! [Expenses])
            let entities = calculations.calculationOfPieChart(expenses)
            let dataSet = PieChartDataSet(entries: entities, label: "")
            
            pieChart.drawEntryLabelsEnabled = false
//            Colors
            let c1 = UIColor(hexString: "#eb4034")
            let c2 = UIColor(hexString: "#ebb734")
            let c3 = UIColor(hexString: "#7aeb34")
            let c4 = UIColor(hexString: "#3499eb")
            let c5 = UIColor(hexString: "#7d34eb")
           
            dataSet.colors = [c1, c2, c3, c4, c5]
//            dataSet.drawValuesEnabled = true
            dataSet.sliceSpace = 2
            
            pieChart.data = PieChartData(dataSet: dataSet)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPopoverFrom(cell: ExpenseTableViewCell, forButton button: UIButton, forNotes notes: String) {
        let buttonFrame = button.frame
        var showRect = cell.convert(buttonFrame, to: expensesTable)
        showRect = expensesTable.convert(showRect, to: view)
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
    

}

extension DetailViewController: ExpenseTableViewCellDelegate {
    func viewNotes(cell: ExpenseTableViewCell, sender button: UIButton, data: String) {
        self.showPopoverFrom(cell: cell, forButton: button, forNotes: data)
    }
}

