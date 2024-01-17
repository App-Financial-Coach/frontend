
import SwiftUI

struct ExpenseBreakdownView: View {
    
    @State private var isDescendingOrder = false
    @Binding var presentSideMenu: Bool
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date()) // Default to the current month
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    private let expenseController = ExpenseViewController()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    
                    if let userProfile = UserManager.shared.currentUser {
                        Spacer()
                        let expensesForSelectedMonth = expenseController.expensesForSelectedMonth(userProfile: userProfile, selectedMonth: selectedMonth, selectedYear: selectedYear)
                        Text("Total Expense Amount: \(expenseController.totalExpenseAmount(expenses: expensesForSelectedMonth)) ₺")
                                        .font(.headline)
                                        .padding()
     
                        HStack {
                            Picker("Select Month", selection: $selectedMonth) {
                                ForEach(1...12, id: \.self) { month in
                                    Text(DateFormatter().monthSymbols[month - 1])
                                        .tag(month)
                                }
                            }
                            .environment(\.locale, Locale(identifier: "en_US"))
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .accentColor(.black)
                        

                            Picker("Select Year", selection: $selectedYear) {
                                ForEach(2020...2023, id: \.self) { year in
                                    Text(String(year))
                                        .tag(year)
                                        .accessibilityLabel(Text("\(year)"))
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .accentColor(.black)
                            
                            
                            Spacer()
                            
                            Button(action: {
                                   isDescendingOrder = true
                               }) {
                                   Image(systemName: "arrow.up.circle.fill")
                                       .resizable()
                                       .frame(width: 20, height: 20)
                                       .foregroundColor(Color("textColor"))
                               }
                               Button(action: {
                                   isDescendingOrder = false
                               }) {
                                   Image(systemName: "arrow.down.circle.fill")
                                       .resizable()
                                       .frame(width: 20, height: 20)
                                       .foregroundColor(Color("textColor"))
                               }
                       }
                       .padding()

                        let sortedExpenses = isDescendingOrder ? expensesForSelectedMonth.sorted { $0.expenseAmount > $1.expenseAmount } : expensesForSelectedMonth.sorted { $0.expenseAmount < $1.expenseAmount }
                        
                        if sortedExpenses.isEmpty {
                            Text("No income to display yet...")
                        }

                        ForEach(sortedExpenses, id: \.expenseId) { expense in
                            ExpenseRowView(expense: expense)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color("gray"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                                )
                                )
                                .padding(.horizontal)
                                .padding(.vertical, 2)
                            }
                    } else {
                        Text("No income to display yet...")
                    }
                }
            }
            .navigationTitle("") // Hide the default navigation title
            .navigationBarItems(leading:
                   Button(action: {
                       presentSideMenu.toggle()
                   }) {
                       Image(systemName: "text.justify.leading")
                           .resizable()
                           .frame(width: 20, height: 20)
                           .foregroundColor(Color("textColor"))
                   }
               )
        }
    }

}

struct ExpenseRowView: View {
    var expense: ExpenseModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.category)
                    .font(.headline)
                    .foregroundColor(Color("textColor"))
                Text("\(formattedDate())")
                    .font(.subheadline)
                    .foregroundColor(Color("textColor"))
            }

            Spacer()

            Text(String(format: "%.2f %@", expense.expenseAmount, "₺"))
                .font(.headline)
                .foregroundColor(Color("textColor"))
        }

    }

    private func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: expense.expenseDate)
    }
}


struct ExpenseBreakdownView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseBreakdownView(presentSideMenu: .constant(false))
    }
}
