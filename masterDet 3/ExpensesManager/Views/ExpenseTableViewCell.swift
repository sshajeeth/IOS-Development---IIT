//
//  ExpenseTableViewCell.swift
//  ExpensesManager
//
//  Created by Shajeeth Suwarnarajah on 2021-05-22.
//  Copyright © 2021 Philip Trwoga. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {
    var cellDelegate: ExpenseTableViewCellDelegate?
    @IBOutlet var expense_name_lbl: UILabel!
    @IBOutlet var expense_budget_lbl: UILabel!
    @IBOutlet var expense_date_lbl: UILabel!
    @IBOutlet var reminderIcon: UIImageView!
    @IBOutlet var expense_due_lbl: UILabel!
    @IBOutlet var progressBar: CircularProgressBarView!
    
    let calculations: Calculation = Calculation()
    override func awakeFromNib() {
       
        super.awakeFromNib()
//
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit1(_ expenseName: String, expenseAmount: Double, expense_date: String, expense_reminder: Bool, occurance: String, categoryBudget: Double, color:String) {
        
        expense_name_lbl.text = expenseName
        expense_budget_lbl.text = "\(expenseAmount)£"
        expense_date_lbl.text = expense_date
        expense_due_lbl.text = occurance
        if expense_reminder == true{
            self.reminderIcon.isHidden = false
            self.reminderIcon.tintColor = UIColor(hexString: color)
        }else if expense_reminder == false{
            self.reminderIcon.isHidden = true
        }
        
        
        self.progressBar.trackColor = UIColor(hexString: "#e3e3e3")
        self.progressBar.progressColor = UIColor(hexString: color)
        
        
        
        let progress = (Float(expenseAmount)/Float(categoryBudget))*1.0
        print("Shajeeth\(progress)")
        self.progressBar.setProgressWithAnimation(progress: progress)
    }
    
}

protocol ExpenseTableViewCellDelegate {
    func customCell(cell: ExpenseTableViewCell, sender button: UIButton, data: String)
}
