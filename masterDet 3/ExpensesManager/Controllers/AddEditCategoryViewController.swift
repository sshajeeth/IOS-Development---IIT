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

class AddEditCategoryViewController: UIViewController {
    @IBOutlet var category_name_tf: UITextField!
    @IBOutlet var category_budget_tf: UITextField!
    @IBOutlet var category_notes_tv: UITextView!
    
    var categories: [ExpensesCategory] = []
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
                categoryName.text = editingCategory?.name
            }
            if let budget = category_budget_tf{
                var categoryBudget = String(format: "%.2f", editingCategory?.budget as! CVarArg)
                budget.text = categoryBudget
            }
            if let notes = category_notes_tv{
                notes.text = editingCategory?.notes
                
            }
            
        }
        
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
