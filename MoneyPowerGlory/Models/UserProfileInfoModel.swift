import Foundation
import FirebaseFirestore

struct UserProfileInfoModel {
    static var shared: UserProfileInfoModel?
    
    let uid: String
    let email: String?
    var date_created: Date
    var currentBalance: Double
    var expenses: [ExpenseModel] // to store user's expenses
    var incomes: [IncomeModel] // to store user's incomes
    
    var dailySpendingLimit: Double { // will be calculated dynamically each time we access it
        let currentDate = Date()
        let currentMonthRange = Calendar.current.range(of: .day, in: .month, for: currentDate)!
        let totalDaysInMonth = currentMonthRange.count
        let remainingDays = totalDaysInMonth - Calendar.current.component(.day, from: currentDate)

        guard remainingDays > 0 else {
            return currentBalance // No remaining days, use current balance as daily limit
        }

        return currentBalance / Double(remainingDays)
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
        self.date_created = Date()
        self.expenses = []
        self.incomes = []
        self.currentBalance = 0.0
    }
    
    init(uid: String, email: String, date_created: Date, currentBalance: Double, expenses: [ExpenseModel], incomes: [IncomeModel]) {
        self.uid = uid
        self.email = email
        self.date_created = date_created
        self.currentBalance = currentBalance
        self.expenses = expenses
        self.incomes = incomes
    }
    
    /*
    static func update(withData userData: [String: Any]) {
       if let currentBalance = userData["currentBalance"] as? Double,
          let dateCreatedTimestamp = userData["date_created"] as? Timestamp {
           
           let dateCreated = dateCreatedTimestamp.dateValue()
           
           var expenses: [ExpenseModel] = []
           if let expensesData = userData["expenses"] as? [[String: Any]] {
               for expenseData in expensesData {
                   let expense = ExpenseModel(data: expenseData)
                   expenses.append(expense)
               }
           }
       }
   }
   */
    
    mutating func addExpense(expense: ExpenseModel) {
            expenses.append(expense)
        }
    mutating func addIncome(income: IncomeModel) {
            incomes.append(income)
        }
}

