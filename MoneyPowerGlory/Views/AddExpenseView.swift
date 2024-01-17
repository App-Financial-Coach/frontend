import SwiftUI
import UIKit


struct AddExpenseView: View {
    @State private var date = Date()
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var receiptPhoto: Image? = nil
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showAlert = false
    @Binding var isHomePageSelected: Bool
    @AppStorage("uid") var userID: String = ""
    @EnvironmentObject var viewModel: ViewModel
    
    
    
    var body: some View {
        NavigationView {
            if !viewModel.isCategorySelection {
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    Spacer()
                    VStack {
                        HStack {
                            Text("New Expense")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(Color("textColor"))
                            
                        }
                        .padding()
                        .padding(.top)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Date:")
                                    .font(.headline)
                                    .foregroundColor(Color("textColor"))
                                Spacer()
                                DatePicker("Date", selection: $date, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .padding()
                            
                            HStack {
                                Text("Amount:")
                                    .font(.headline)
                                    .foregroundColor(Color("textColor"))
                                Spacer()
                                TextField("111.5", text: $amount)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                Image(systemName: "turkishlirasign")
                                    .foregroundColor(Color("textColor"))
                            }
                            .padding()
                            
                            HStack {
                                Text("Category:")
                                    .font(.headline)
                                Spacer()
                                //TextField("Groceries", text: $category)
                                    .multilineTextAlignment(.trailing)
                                VStack {
                                    Button(action: {
                                        viewModel.isCategorySelection = true
                                    }) {
                                        Image(systemName: viewModel.selectedCategory?.systemImageName ?? "house.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color(viewModel.selectedCategory?.color ?? .systemBlue))
                                    }
                                    Text(viewModel.selectedCategory?.name ?? "Rent/Mortgage")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 4)
                                    
                                }
                            }
                            .padding()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.white))
                        )
                        .padding()
                        
                        Spacer()
                        Spacer()
                        
                        Button {
                            let expenseId = UUID().uuidString
                            UserManager.shared.fetchUserData(userID: userID) {
                                if var userProfile = UserManager.shared.currentUser {
                                    let expense = ExpenseModel(
                                        expenseId: expenseId,
                                        userId: userProfile.uid,
                                        expenseAmount: Double(amount) ?? 0.0,
                                        expenseDate: date,
                                        category: viewModel.selectedCategory?.tag ?? "rent", // You may want to provide a default category
                                        parentCategory: viewModel.selectedCategory?.parentCategory ?? "Housing", // Provide a default parent category or change as needed
                                        oldBalance: userProfile.currentBalance,
                                        newBalance: userProfile.currentBalance - (Double(amount) ?? 0.0)
                                    )
                                    userProfile.addExpense(expense: expense)
                                    UserManager.shared.addExpenseData(){}
                                    amount = ""
                                    viewModel.selectedCategory = nil
                                    showAlert = true // Show alert
                                }
                            }
                        } label: {
                            Text("Add Expense")
                                .foregroundColor(.white)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color("darkPurple"))
                                )
                                .padding(.horizontal)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Expense Added"),
                                message: Text("Your expense has been added."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                }
            } else {
                ExpenseCategoriesView()
            }
        }
    }
}


struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        AddExpenseView(isHomePageSelected: .constant(false)).environmentObject(viewModel)
    }
}

class ViewModel: ObservableObject {
    @Published var isCategorySelection = false
    @Published var selectedCategory: ExpenseCategory?
}

