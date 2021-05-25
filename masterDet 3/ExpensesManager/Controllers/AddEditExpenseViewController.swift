//
//  AddEditExpenseViewController.swift
//  ExpensesManager
//
//  Created by Shajeeth Suwarnarajah on 2021-05-21.
//  Copyright © 2021 Philip Trwoga. All rights reserved.
//

import UIKit
import EventKit
import CoreData

class AddEditExpenseViewController: UIViewController {
    @IBOutlet var expense_category_lbl: UILabel!
    @IBOutlet var expense_name_tf: UITextField!
    @IBOutlet var expense_amount_tf: UITextField!
    @IBOutlet var expense_notes_tv: UITextView!
    @IBOutlet var expense_date_picker: UIDatePicker!
    @IBOutlet var expense_reminder_toggle: UISwitch!
    @IBOutlet var expense_reminder_occurance_segment: UISegmentedControl!
    @IBOutlet var expense_save_btn: UIBarButtonItem!
    
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
    
    //    let ekrules: EKRecurrenceRule
    override func viewDidLoad() {
        super.viewDidLoad()
        expense_category_lbl.text = detailItem?.name
        // Do any additional setup after loading the view.
        configureView()
    }
    
    func configureView() {
        if editingMode {
            self.navigationItem.title = "Edit Expense"
        }
        
        if let expense = editingExpense{
            if let expenseName = expense_name_tf{
                expenseName.text = editingExpense?.name
            }
            if let expenseAmount = expense_amount_tf{
                var expenseBudget = String(format: "%.2f", editingExpense?.amount as! CVarArg)
                
                expenseAmount.text = expenseBudget
            }
            if let expenseNotes = expense_notes_tv{
                expenseNotes.text = editingExpense?.notes
            }
//            if let expenseDate = expense_date_picker{
//                let finalDate = self.convertStringDateToDate(date: (editingExpense?.date)!)
//                expenseDate.setDate(finalDate, animated: true)
//            }
            
            if let expenseReminder = expense_reminder_toggle{
                if editingExpense?.reminder == true{
                    expenseReminder.setOn(true, animated: true)
                }else {
                    expenseReminder.setOn(false, animated: true)
                }
            }
            
            if let expenseOccurance = expense_reminder_occurance_segment{
                let occurance = editingExpense?.ocurance
                if occurance == "Never"{
                    expenseOccurance.setEnabled(true, forSegmentAt: 0)
                }else if occurance == "Daily"{
                    expenseOccurance.setEnabled(true, forSegmentAt: 1)
                }else if occurance == "Weekly"{
                    expenseOccurance.setEnabled(true, forSegmentAt: 2)
                }else if occurance == "Monthly"{
                    expenseOccurance.setEnabled(true, forSegmentAt: 3)
                }
                
            }
            
            
        }
        
    }
    @IBAction func saveExpense(_ sender: UIBarButtonItem) {
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
        self.dismissPopUp()
    }
    @IBAction func cancelExpense(_ sender: UIBarButtonItem) {
        self.dismissPopUp()
    }
    
    @IBAction func dateHandle(_ sender: UIDatePicker)
    {
        let dateFormatr = DateFormatter()
        dateFormatr.dateFormat = "dd MMMM, h:mm a"
        strDate = dateFormatr.string(from: (expense_date_picker?.date)!)
        print(strDate)
        
        
        //        strDate = dateFormatter.string(from: expense_date_picker.date)
    }
    
    
    func convertStringDateToDate(date: String) -> Date{
        let dateFormatter = DateFormatter()
        let final_date = dateFormatter.date(from: date)
        
        return final_date!
    }
    
    
    
    
    
    
    @IBAction func handleExpenseReminderToggle(_ sender: Any) {
        if expense_reminder_toggle.isOn{
            print("Switch ON")
            reminder = true
            expense_reminder_occurance_segment.isUserInteractionEnabled = true
        }else{
            reminder = false
            print("Switch OFF")
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
