import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import UIKit

final class UserManager {
    
    @AppStorage("uid") var userID: String = ""
    static let shared = UserManager()
    @Published var currentUser: UserProfileInfoModel?
    private init() {}
    
    
    /**
     Called after sign in.
     Creates new user and writes it into database
     */
    func createNewUser(user: UserProfileInfoModel){
        var userData: [String:Any] = [
            "user_id": user.uid,
            "date_created": user.date_created
        ]
        if let email = user.email {
            userData["email"] = email
        }
        Firestore.firestore().collection("users").document(user.uid).setData(userData, merge: false)
        
        UserManager.shared.currentUser = UserProfileInfoModel(uid: user.uid, email: user.email ?? "")
    
    }
    
    
    /**
     Called after login
     Fetches user's existing data from database.
     */
    func fetchUserData(userID: String, completion: @escaping () -> Void) {
        let userRef = Firestore.firestore().collection("users").document(userID)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("document is found")
                let userData = document.data()
                if let email = userData?["email"] as? String,
                   let dateCreatedTimestamp = userData?["date_created"] as? Timestamp {
                    
                    let dateCreated = dateCreatedTimestamp.dateValue()
                    let currentBalance = userData?["currentBalance"] as? Double ?? 0.0
                    
                    // Initialize UserProfileInfoModel with the retrieved data
                    var userProfile = UserProfileInfoModel(
                        uid: userID,
                        email: email,
                        date_created: dateCreated,
                        currentBalance: currentBalance,
                        expenses: [],
                        incomes: []
                    )
                    
                    if let expensesData = userData?["expenses"] as? [[String: Any]] {
                        let expenses = expensesData.map { ExpenseModel(data: $0) }
                        userProfile.expenses = expenses
                    }
                    
                    // Fetch incomes if they exist in the user data
                    if let incomesData = userData?["incomes"] as? [[String: Any]] {
                        let incomes = incomesData.map { IncomeModel(data: $0) }
                        userProfile.incomes = incomes
                    }
                    

                    UserManager.shared.currentUser = userProfile

                    completion()
                } else {
                    print("Error parsing user data from Firestore")
                    completion()
                }
            } else {
                print("User document not found in Firestore")
                completion()
            }
        }
    }
    
    
    /**
     Called after add expense method.
     Adds new expense information to the database.
     */

    func addExpenseData(completion: @escaping () -> Void) {
        print("addition of expense data is started")
        if let userProfile = UserManager.shared.currentUser {
            let userDocumentRef = Firestore.firestore().collection("users").document(userProfile.uid)
            UserManager.shared.fetchUserData(userID: userID){
                let updatedFields: [String: Any] = [
                    "expenses": userProfile.expenses.map { $0.expenseModelDictRepresentation }
                ]
                print(userProfile.expenses.map { $0.expenseModelDictRepresentation })
                // Update the user's document in Firestore
                userDocumentRef.setData(updatedFields, merge: true) { error in
                    if let error = error {
                        print("Error updating user document: \(error.localizedDescription)")
                    } else {
                        print("User document updated successfully.")
                    }
                    completion()
                }

            }
        }
    }
    
    
    func addIncomeData(completion: @escaping () -> Void) {
        print("Addition of income data is started")
        if let userProfile = UserManager.shared.currentUser {
            let userDocumentRef = Firestore.firestore().collection("users").document(userProfile.uid)
            UserManager.shared.fetchUserData(userID: userID) {
                let updatedFields: [String: Any] = [
                    "incomes": userProfile.incomes.map { $0.incomeModelDictRepresentation }
                ]
                print(userProfile.incomes.map { $0.incomeModelDictRepresentation }) // Make sure this works

                // Update the user's document in Firestore
                userDocumentRef.setData(updatedFields, merge: true) { error in
                    if let error = error {
                        print("Error updating user document: \(error.localizedDescription)")
                    } else {
                        print("User document updated successfully.")
                    }
                    completion()
                }
            }
        }
    }

}


