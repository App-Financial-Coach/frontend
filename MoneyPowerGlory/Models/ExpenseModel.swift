import Foundation
import FirebaseFirestore

struct ExpenseModel {
    let expenseId: String
    let userId: String // Foreign key referencing user table
    let expenseAmount: Double
    let expenseDate: Date
    let category: String
    let parentCategory: String
    let riskProfileScore: Double
    let oldBalance: Double // balance before the transaction occured
    let newBalance: Double // balance after the transaction occured
    
    init(expenseId: String, userId: String, expenseAmount: Double, expenseDate: Date, category: String, parentCategory: String, oldBalance: Double, newBalance: Double) {
        self.expenseId = expenseId
        self.userId = userId
        self.expenseAmount = expenseAmount
        self.expenseDate = expenseDate
        self.category = category
        self.parentCategory = parentCategory
        self.riskProfileScore = 0
        self.oldBalance = oldBalance
        self.newBalance = newBalance
        
    }
    
    init(data: [String: Any]) {
        self.expenseId = data["expenseId"] as? String ?? ""
        self.userId = data["userId"] as? String ?? ""
        self.expenseAmount = data["expenseAmount"] as? Double ?? 0.0

        if let timestamp = data["expenseDate"] as? Timestamp {
            self.expenseDate = timestamp.dateValue()
        } else {
            self.expenseDate = Date()
        }

        self.category = data["category"] as? String ?? ""
        self.parentCategory = data["parentCategory"] as? String ?? ""
        self.riskProfileScore = data["riskProfileScore"] as? Double ?? 0.0
        self.oldBalance = data["oldBalance"] as? Double ?? 0.0
        self.newBalance = data["newBalance"] as? Double ?? 0.0
    }
}

extension ExpenseModel {
    var expenseModelDictRepresentation: [String: Any] {
        return [
            "expenseId": expenseId,
            "userId": userId,
            "expenseAmount": expenseAmount,
            "expenseDate": Timestamp(date: expenseDate),
            "category": category,
            "parentCategory": parentCategory,
            "oldBalance": oldBalance,
            "newBalance": newBalance
        ]
    }
}
