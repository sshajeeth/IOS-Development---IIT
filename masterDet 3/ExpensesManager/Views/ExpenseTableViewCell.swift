import UIKit

class ExpenseTableViewCell: UITableViewCell {
    @IBOutlet var expense_name_lbl: UILabel!
    @IBOutlet var expense_budget_lbl: UILabel!
    @IBOutlet var expense_date_lbl: UILabel!
    @IBOutlet var reminderIcon: UIImageView!
    @IBOutlet var expense_due_lbl: UILabel!
    @IBOutlet var progressBar: CircularProgressBarView!
    
    @IBOutlet var expense_notes_icon: UIView!
    var cellDelegate: ExpenseTableViewCellDelegate?
    var notes: String = "Not Available"
    let calculations: Calculation = Calculation()
    override func awakeFromNib() {
       
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func commonInit1(_ expenseName: String, expenseAmount: Double, expense_date: String, expense_reminder: Bool, occurance: String, categoryBudget: Double, color:String, notes:String) {
        expense_notes_icon.tintColor = UIColor(hexString: color)
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
        self.progressBar.setProgressWithAnimation(progress: progress)
        
        self.notes = notes
    }
    
    @IBAction func openNotes(_ sender: UIButton) {
        self.cellDelegate?.viewNotes(cell: self, sender: sender as! UIButton, data: notes)
    }
}

protocol ExpenseTableViewCellDelegate {
    func viewNotes(cell: ExpenseTableViewCell, sender button: UIButton, data: String)
}
