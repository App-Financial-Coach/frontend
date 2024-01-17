import SwiftUI

struct IncomeBreakdownView: View {
    @Binding var presentSideMenu: Bool
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Income Breakdown")
                        .font(.title)
                        .bold()
                        .padding()
                    
                    if let userProfile = UserManager.shared.currentUser {
                        ForEach(userProfile.incomes, id: \.incomeId) { income in
                            IncomeRowView(income: income)
                                .padding()
                                .background(Color("backgroundColor"))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    } else {
                        Text("No income to display yet...")
                    }
                }
                .padding()
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

struct IncomeRowView: View {
    var income: IncomeModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(income.incomeName)
                    .font(.headline)
                    .foregroundColor(ColorPalette.textColor)

                Text("Fixed: \(income.isFixedIncome ? "Yes" : "No")")
                    .font(.subheadline)
                    .foregroundColor(ColorPalette.gray)
            }

            Spacer()

            Text(String(format: "%.2f %@", income.incomeAmount, "₺"))
                .font(.headline)
                .foregroundColor(ColorPalette.textColor)
        }
    }
}


struct IncomeBreakdownView_Previews: PreviewProvider {
    static var previews: some View {
        IncomeBreakdownView(presentSideMenu: .constant(false))
    }
}
