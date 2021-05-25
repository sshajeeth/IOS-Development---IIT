//
//  CategoryTableViewCell.swift
//  ExpensesManager
//
//  Created by Shajeeth Suwarnarajah on 2021-05-21.
//  Copyright © 2021 Philip Trwoga. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    var cellDelegate: CategoryTableViewCellDelegate?
    var notes: String = "Not Available"
    
    
    @IBOutlet var category_name_lbl: UILabel!
    @IBOutlet var category_budget_lbl: UILabel!
    @IBOutlet var category_notes_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func commonInit(_ categoryName: String, categoryBudget: Double, categoryNotes: String) {
        
        category_name_lbl.text = categoryName
        category_budget_lbl.text = "Budget: \(categoryBudget)£"
        category_notes_lbl.text = categoryNotes
    }
    
}

protocol CategoryTableViewCellDelegate {
    func customCell(cell: CategoryTableViewCell, sender button: UIButton, data: String)
}



