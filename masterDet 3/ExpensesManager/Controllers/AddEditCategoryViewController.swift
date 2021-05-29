//
//  AddEditCategoryViewController.swift
//  ExpensesManager
//
//  Created by Shajeeth Suwarnarajah on 2021-05-20.
//  Copyright © 2021 Philip Trwoga. All rights reserved.
//

import UIKit
import CoreData

enum color: Int {
    case blue, red, green, yellow, orange, purple, gray
}

class AddEditCategoryViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var category_name_tf: UITextField!
    @IBOutlet var category_budget_tf: UITextField!
    @IBOutlet var category_notes_tv: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var color_name = "#000000"
    var editingMode: Bool = false
    
    var editingCategory: ExpensesCategory? {
        didSet {
            // Update the view.
            editingMode = true
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !editingMode {
            // Settings the placeholder for notes UITextView
            category_notes_tv.delegate = self
            category_notes_tv.text = "Notes"
            category_notes_tv.textColor = UIColor.lightGray
        }
        configureView()
        // Do any additional setup after loading the view.
    }
    
    
    func configureView() {
        if editingMode {
            self.navigationItem.title = "Edit Category"
            self.navigationItem.rightBarButtonItem?.title = "Save"
        }
        
        if let category = editingCategory{
            if let categoryName = category_name_tf{
                categoryName.text = category.name
            }
            if let budget = category_budget_tf{
                var categoryBudget = String(format: "%.2f", category.budget as! CVarArg)
                budget.text = categoryBudget
            }
            if let notes = category_notes_tv{
                notes.text = category.notes
                
            }
            
            color_name = category.color!
                
            
            
        }
        
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        if validateFields(){
        let entity = NSEntityDescription.entity(forEntityName: "ExpensesCategory", in: context)!
        var category = NSManagedObject()
        
        if editingMode {
            category = (editingCategory as? ExpensesCategory)!
        } else {
            category = NSManagedObject(entity: entity, insertInto: context)
        }
        
        category.setValue(self.category_name_tf.text, forKey: "name")
        category.setValue(Double(self.category_budget_tf.text!), forKey: "budget")
        category.setValue(self.category_notes_tv.text, forKey: "notes")
        category.setValue(self.color_name, forKey: "color")
        
    
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        
        self.dismissPopUp()
        let date = NSDate()
        category.setValue(date, forKey: "addedDate")
        }else{
            let alert = UIAlertController(title: "Error", message: "Please fill the required fields.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func cancelCategory(_ sender: UIBarButtonItem) {
        self.dismissPopUp()
    }
    
    @IBAction func selectColor(_ sender: UIButton) {
        switch color(rawValue: sender.tag)! {
        case .blue:
            color_name = "#abd5ff"
        case .red:
            color_name = "#ffabab"
        case .green:
            color_name = "#b8ffab"
        case .yellow:
            color_name = "#ffe08c"
        case .orange:
            color_name = "#ffba8c"
        case .purple:
            color_name = "#dcabff"
        case .gray:
            color_name = "#e0e0e0"
        }
    }
    
    
    func dismissPopUp(){
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
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
        if !(category_name_tf.text!.isEmpty) && !(category_budget_tf.text!.isEmpty){
            return true
        }else{
            return false
        }
    }
    
}
