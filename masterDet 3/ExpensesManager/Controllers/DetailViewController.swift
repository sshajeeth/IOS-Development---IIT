

import UIKit
import CoreData
import Charts

class DetailViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITableViewDelegate{
    
    
    
    @IBOutlet var expensesTable: UITableView!
    @IBOutlet var progressBar: CircularProgressBarView!
    @IBOutlet var pieChart: PieChartView!
    @IBOutlet var category_name_lbl: UILabel!
    @IBOutlet var budget_lbl: UILabel!
    @IBOutlet var amount_lbl: UILabel!
    @IBOutlet var remaining_lbl: UILabel!
    
    let calculations: Calculation = Calculation()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.detailItem != nil){
            let sectionInfo = self._fetchResultsController.sections![section] as NSFetchedResultsSectionInfo
            return sectionInfo.numberOfObjects
        }else{
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.detailItem != nil){
            return self._fetchResultsController.sections?.count ?? 1
            
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as! ExpenseTableViewCell
        //        let event = _fetchedResultsController!.object(at: indexPath)
        //        configureCell(cell as! CategoryTableViewCell, withEvent: event)
        //        configureCell(cell as! CategoryTableViewCell, withEvent: event)
        configureCell(cell, indexPath: indexPath)
        //        cell.cellDelegate = self
        return cell
    }
    
    
    
    var detailItem: ExpensesCategory?
    
    
    
    //    MARK: - Fetched results controller
    
    var _fetchedResultsController: NSFetchedResultsController<Expenses>? = nil
    
    var _fetchResultsController: NSFetchedResultsController<Expenses> {
        if _fetchedResultsController != nil{
            return _fetchedResultsController!
        }
        let fetchRequest: NSFetchRequest<Expenses> = Expenses.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "category = %@", detailItem as! ExpensesCategory)
        fetchRequest.predicate = predicate
        
        let aFetchedResultsController = NSFetchedResultsController<Expenses>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: #keyPath(Expenses.expense_category), cacheName: "\(UUID().uuidString)-category")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        
        
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
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        expensesTable.beginUpdates()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            context.delete(_fetchResultsController.object(at: indexPath))
            
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
    
    func configureCell(_ cell: ExpenseTableViewCell, indexPath: IndexPath) {
        
        if(self.detailItem != nil){
            let name = (self._fetchedResultsController?.fetchedObjects?[indexPath.row].name)!
            let expense = (self._fetchedResultsController?.fetchedObjects?[indexPath.row].amount)!
            let date = self._fetchedResultsController?.fetchedObjects?[indexPath.row].date
            let reminder = self._fetchedResultsController?.fetchedObjects?[indexPath.row].reminder
            let occurance = self._fetchedResultsController?.fetchedObjects?[indexPath.row].ocurance
            let categoryBudget = (self.detailItem?.budget)!
            let color = self.detailItem?.color
            cell.commonInit1(name, expenseAmount: Double(expense), expense_date: date!, expense_reminder: reminder!, occurance: occurance!, categoryBudget: Double(categoryBudget),color: color!)
            
        }
        //
    }
    
    //    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    //        switch type {
    //        case .insert:
    //            expensesTable.insertSections(IndexSet(integer: sectionIndex), with: .fade)
    //        case .delete:
    //            expensesTable.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
    //        default:
    //            return
    //        }
    //    }
    
    //    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    //        switch type {
    //            case .insert:
    //                expensesTable.insertRows(at: [newIndexPath!], with: .fade)
    //            case .delete:
    //                expensesTable.deleteRows(at: [indexPath!], with: .fade)
    //            case .update:
    //                configureCell(expensesTable.cellForRow(at: indexPath!)! as! ExpenseTableViewCell, indexPath: indexPath!.se)
    ////                configureCell(expensesTable.cellForRow(at: indexPath!)! as! ExpenseTableViewCell, indexPath: indexPath!)
    //            case .move:
    //                configureCell(expensesTable.cellForRow(at: indexPath!)! as! ExpenseTableViewCell, indexPath: indexPath!)
    //            default:
    //                return
    //        }
    //    }
    
    
    
    
    
    func configureView() {
        if let category = detailItem{
            let expenses = (category.expenses!.allObjects as! [Expenses])
            
            let totalExpenses = calculations.calculate_total_expenses(expenses)
            progressBar.trackColor = UIColor(hexString: "#e3e3e3")
            //            print(categoryColor)
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
            }
            
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expensesTable.dataSource = self
        let nibName = UINib(nibName: "ExpenseTableViewCell", bundle: nil)
        expensesTable.register(nibName, forCellReuseIdentifier: "expenseCell")
        self.configureView()
        self.setupPieChart()
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
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the default selected row
        let indexPath = IndexPath(row: 0, section: 0)
        if expensesTable.hasRowAtIndexPath(indexPath: indexPath as NSIndexPath) {
            expensesTable.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier{
            //            case "categoryDeatils":
            //                let destVC = segue.destination as! CategoryDetailController
            //
            //                if let name = self.detailItem?.name{
            //                    destVC.categoryName = name
            //                }
            //
            //                if let budget = self.detailItem?.budget{
            //                    destVC.categoryTotalBudget = Float(budget)
            //                }
            //
            //                if let color = self.detailItem?.color{
            //                    destVC.categoryColor = color
            //                }
            
            
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
                }
                
            default:
                break
            }
        }
    }
    
    
}

