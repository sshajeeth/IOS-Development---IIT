import Foundation
import Charts

class Calculation{
    
    func calculate_total_expenses(_ expenses: [Expenses]) -> Float{
        var totalExpenses: Float = 0.0
        
        if expenses.count > 0{
            for expense in expenses{
                totalExpenses += Float(expense.amount)
            }
        }
        
//        print(totalExpenses)
        return totalExpenses
    }
    
    
    
    func calculationOfPieChart(_ expensesDB: [Expenses]) -> Array<PieChartDataEntry>{
        struct Expense{
            var amount:Double
            var name:String
        }
        var expenses:[Expense]=Array()
        
        var finalExpenses:[PieChartDataEntry] = Array()
        var final_expense = 0.0
        for expense in expensesDB{
            expenses.append(Expense(amount: expense.amount, name: expense.name!))
        }
        
        var sortedExpenses = expenses.sorted(by: {$0.amount > $1.amount})
    
        
        if expenses.count>4{
            finalExpenses.append(PieChartDataEntry(value: sortedExpenses[0].amount, label: sortedExpenses[0].name))
            finalExpenses.append(PieChartDataEntry(value: sortedExpenses[1].amount, label: sortedExpenses[1].name))
            finalExpenses.append(PieChartDataEntry(value: sortedExpenses[2].amount, label: sortedExpenses[2].name))
            finalExpenses.append(PieChartDataEntry(value: sortedExpenses[3].amount, label: sortedExpenses[3].name))
            
            for i in 4..<sortedExpenses.count{
                print(i)
                final_expense += expenses[i].amount
            }
            finalExpenses.append(PieChartDataEntry(value: final_expense, label: "Other Expenses"))
        }else if expenses.count==4{
            finalExpenses.append(PieChartDataEntry(value: sortedExpenses[0].amount, label: sortedExpenses[0].name))
            finalExpenses.append(PieChartDataEntry(value: sortedExpenses[1].amount, label: sortedExpenses[1].name))
            finalExpenses.append(PieChartDataEntry(value: sortedExpenses[2].amount, label: sortedExpenses[2].name))
            finalExpenses.append(PieChartDataEntry(value: sortedExpenses[3].amount, label: sortedExpenses[3].name))

        }else if expenses.count==3{
            finalExpenses.append(PieChartDataEntry(value: sortedExpenses[0].amount, label: sortedExpenses[0].name))
            finalExpenses.append(PieChartDataEntry(value: sortedExpenses[1].amount, label: sortedExpenses[1].name))
            finalExpenses.append(PieChartDataEntry(value: sortedExpenses[2].amount, label: sortedExpenses[2].name))
           
        }else if expenses.count==2{
            finalExpenses.append(PieChartDataEntry(value: sortedExpenses[0].amount, label: sortedExpenses[0].name))
            finalExpenses.append(PieChartDataEntry(value: sortedExpenses[1].amount, label: sortedExpenses[1].name))
        }else if expenses.count==1{
            finalExpenses.append(PieChartDataEntry(value: sortedExpenses[0].amount, label: sortedExpenses[0].name))
        }
        return finalExpenses
    }
}
