//
//  AddDetailViewController.swift
//  masterDet
//
//  Created by Shajeeth Suwarnarajah on 2021-05-20.
//  Copyright © 2021 Philip Trwoga. All rights reserved.
//

import UIKit
import CoreData
class CategoryDetailController: UIViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet var category_heading_lbl: UILabel!
    @IBOutlet var category_total_budget_lbl: UILabel!
    @IBOutlet var category_spent_lbl: UILabel!
    @IBOutlet var category_remaining_lbl: UILabel!
    @IBOutlet var category_progress_view: CircularProgressBarView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryName = ""
    var categoryTotalBudget:Float = 0.0
//    var totalExpenses:Float = 0.0
    var categoryColor = "#000000"
    var categorySpent = 0
    var categoryRemain = 0
    
    var detailItem : Expenses?
//    var detailItem1 : ExpensesCategory?
    var detailItem1: ExpensesCategory? {
        didSet {
            // Update the view.
            configureProgressBar()
        }
    }
    let calculations: Calculation = Calculation()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        category_heading_lbl.text = categoryName
//        category_total_budget_lbl.text = "\(categoryTotalBudget)"
        
      
        
        self.configureProgressBar()
        
    }

    func configureProgressBar(){
        if let category = detailItem1{
            print("Coming Here")
            let expenses = (category.expenses!.allObjects as! [Expenses])
            let totalExpenses = calculations.calculate_total_expenses(expenses)
            category_progress_view.trackColor = UIColor(hexString: "#e3e3e3")
            print(categoryColor)
            category_progress_view.progressColor = UIColor(hexString: categoryColor)
            category_progress_view.setProgressWithAnimation(progress: (totalExpenses/categoryTotalBudget)*1.0)
        }
       
        
        
    }
    

   

}
