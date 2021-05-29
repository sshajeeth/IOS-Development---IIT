import UIKit
import EventKit
import CoreData

class AddEditExpenseViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var expense_category_lbl: UILabel!
    @IBOutlet var expense_name_tf: UITextField!
    @IBOutlet var expense_amount_tf: UITextField!
    @IBOutlet var expense_notes_tv: UITextView!
    @IBOutlet var expense_date_picker: UIDatePicker!
    @IBOutlet var expense_reminder_toggle: UISwitch!
    @IBOutlet var expense_reminder_occurance_segment: UISegmentedControl!
    @IBOutlet var expense_save_btn: UIBarButtonItem!
    
    var expenses: [NSManagedObject] = []
    var detailItem:ExpensesCategory?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var strDate = ""
    var reminder = true
    var occurance = ""
    var editingMode: Bool = false
    
    var editingExpense: Expenses? {
        didSet {
            // Update the view.
            editingMode = true
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expense_category_lbl.text = detailItem?.name
        
        if !editingMode {
            // Settings the placeholder for notes UITextView
            expense_notes_tv.delegate = self
            expense_notes_tv.text = "Notes"
            expense_notes_tv.textColor = UIColor.lightGray
            
        }
        configureView()
    }
    
    func configureView() {
        if editingMode {
            self.navigationItem.title = "Edit Expense"
        }
        
        if let expense = editingExpense{
            if let expenseName = expense_name_tf{
                expenseName.text = expense.name
            }
            if let expenseAmount = expense_amount_tf{
                var expenseBudget = String(format: "%.2f", expense.amount as! CVarArg)
                
                expenseAmount.text = expenseBudget
            }
            if let expenseNotes = expense_notes_tv{
                expenseNotes.text = expense.notes
            }
            if let expenseDate = expense_date_picker{
                let dateFormatr = DateFormatter()
                dateFormatr.dateFormat = "dd MMMM, h:mm a"
                expenseDate.date = dateFormatr.date(from: expense.date!)!
            }
            
            if let expenseReminder = expense_reminder_toggle{
                if expense.reminder == true{
                    expenseReminder.setOn(true, animated: true)
                }else {
                    expenseReminder.setOn(false, animated: true)
                }
            }
            
            if let expenseOccurance = expense_reminder_occurance_segment{
                let occurance = expense.ocurance
                if occurance == "Never"{
                    expenseOccurance.selectedSegmentIndex = 0
                }else if occurance == "Daily"{
                    expenseOccurance.selectedSegmentIndex = 1
                }else if occurance == "Weekly"{
                    expenseOccurance.selectedSegmentIndex = 2
                }else if occurance == "Monthly"{
                    expenseOccurance.selectedSegmentIndex = 3
                }
                
            }
            
            
        }
        
    }
    
    @IBAction func saveExpense(_ sender: UIBarButtonItem) {
        if validateFields(){
            let entity = NSEntityDescription.entity(forEntityName: "Expenses", in: context)!
            var expense = NSManagedObject()
            
            if editingMode {
                expense = (editingExpense as? Expenses)!
            } else {
                expense = NSManagedObject(entity: entity, insertInto: context)
            }
            
            expense.setValue(expense_name_tf.text, forKey: "name")
            expense.setValue(Double(expense_amount_tf.text!), forKey: "amount")
            expense.setValue(expense_name_tf.text, forKey: "notes")
            expense.setValue(self.strDate, forKey: "date")
            expense.setValue(self.reminder, forKey: "reminder")
            expense.setValue(self.occurance, forKey: "ocurance")
            expense.setValue(detailItem?.name, forKey: "expense_category")
            expense.setValue(expense_name_tf.text, forKey: "name")
            
            
            
            if self.reminder == true{
                self.addReminder(eventTitle: expense_name_tf.text! , eventStartDate: expense_date_picker.date, eventNotes: expense_notes_tv.text!)
            }
            
            detailItem?.addToExpenses((expense as? Expenses)!)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            expenses.append(expense)
            self.dismissPopUp()
        }else{
            let alert = UIAlertController(title: "Error", message: "Please fill the required fields.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancelExpense(_ sender: UIBarButtonItem) {
        self.dismissPopUp()
    }
    
    @IBAction func dateHandle(_ sender: UIDatePicker)
    {
        let dateFormatr = DateFormatter()
        dateFormatr.dateFormat = "dd MMMM, h:mm a"
        strDate = dateFormatr.string(from: (expense_date_picker?.date)!)
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notes"
            textView.textColor = UIColor.lightGray
        }
        
    }
    
    func validateFields() -> Bool {
        if !(expense_name_tf.text!.isEmpty) && !(expense_amount_tf.text!.isEmpty){
            return true
        }else{
            return false
        }
    }
    
    @IBAction func handleExpenseReminderToggle(_ sender: Any) {
        if expense_reminder_toggle.isOn{
            reminder = true
            expense_reminder_occurance_segment.isUserInteractionEnabled = true
        }else{
            reminder = false
            expense_reminder_occurance_segment.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func handleExpenseOccuranceSegment(_ sender: UISegmentedControl) {
        
        if expense_reminder_occurance_segment.isEnabled{
            switch expense_reminder_occurance_segment.selectedSegmentIndex{
            case 0:
                occurance = "Never"
                
            case 1:
                occurance = "Daily"
                
            case 2:
                occurance = "Weekly"
                
            case 3:
                occurance = "Monthly"
                
            default:
                occurance = "Never"
                
            }
        }
    }
    
    //    MARK: - Create Event in Calender
    func addReminder(eventTitle: String, eventStartDate:Date, eventNotes: String) {
        let eventStore:EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event){ (granted, error) in
            if (granted) && (error == nil){
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = eventTitle
                event.startDate = eventStartDate
                event.notes = eventNotes
                event.endDate = eventStartDate
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                if self.occurance == "Daily"{
                    event.recurrenceRules =  [EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: nil)]
                }else if self.occurance == "Weekly"{
                    event.recurrenceRules =  [EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: nil)]
                }else if self.occurance == "Monthly"{
                    event.recurrenceRules =  [EKRecurrenceRule(recurrenceWith: .monthly, interval: 1, end: nil)]
                }
                
                
                do{
                    try eventStore.save(event, span: .thisEvent)
                }catch let error as NSError{
                    print("error : \(error)")
                }
                print("Event Saved")
            }else{
                print("error: \(error)")
            }
        }
    }
    
    func dismissPopUp(){
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    
}
