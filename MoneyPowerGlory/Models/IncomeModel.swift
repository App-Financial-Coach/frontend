import Foundation
import FirebaseFirestore

struct IncomeModel {
    var incomeId: String
    var userId: String
    var incomeAmount: Double
    var incomeDate: Date
    var isFixedIncome: Bool
    var incomeName: String
    var oldBalance: Double
    var newBalance: Double
    
    init(incomeId: String, userId: String, incomeAmount: Double, incomeDate: Date, isFixedIncome: Bool, incomeName: String, oldBalance: Double, newBalance: Double) {
            self.incomeId = incomeId
            self.userId = userId
            self.incomeAmount = incomeAmount
            self.incomeDate = incomeDate
            self.isFixedIncome = isFixedIncome
            self.incomeName = incomeName
            self.oldBalance = oldBalance
            self.newBalance = newBalance
    }


    init(data: [String: Any]) {
        self.incomeId = data["incomeId"] as? String ?? ""
        self.userId = data["userId"] as? String ?? ""
        self.incomeAmount = data["incomeAmount"] as? Double ?? 0.0

        if let timestamp = data["incomeDate"] as? Timestamp {
            self.incomeDate = timestamp.dateValue()
        } else {
            self.incomeDate = Date()
        }

        self.isFixedIncome = data["isFixedIncome"] as? Bool ?? false
        self.incomeName = data["incomeName"] as? String ?? ""
        self.oldBalance = data["oldBalance"] as? Double ?? 0.0
        self.newBalance = data["newBalance"] as? Double ?? 0.0
    }
}

extension IncomeModel {
    var incomeModelDictRepresentation: [String: Any] {
        return [
            "incomeId": incomeId,
            "userId": userId,
            "incomeAmount": incomeAmount,
            "incomeDate": Timestamp(date: incomeDate),
            "isFixedIncome": isFixedIncome,
            "incomeName": incomeName,
            "oldBalance": oldBalance,
            "newBalance": newBalance
        ]
    }
}
