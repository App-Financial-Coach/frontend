import SwiftUI

struct HomePageView: View {
    
    @Binding var presentSideMenu: Bool
    @Binding var isHomePageSelected: Bool
    
    private let homeController = HomeViewController()
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image(systemName: "text.justify.leading")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("textColor"))
                }
                
                Spacer()
                Spacer()
                
                Button{
                    isHomePageSelected.toggle()
                    AddExpenseView(isHomePageSelected: $isHomePageSelected)
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("textColor"))
                }
                
            }
            
            Spacer()
            if let userProfile = UserManager.shared.currentUser {
                    let daysLeft = homeController.daysLeftInMonth() ?? 1
                    let dailyLimit = userProfile.currentBalance / Double(daysLeft)
                    Text("Your daily spending limit:")
                        .font(.headline)
                        .padding()
                        .foregroundColor(Color("textColor"))
                    Text(String(format: "%.2f %@", dailyLimit, "₺"))
                    }
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    func daysLeftInMonth() -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()

        // Get the range of days in the current month
        guard let currentMonthRange = calendar.range(of: .day, in: .month, for: currentDate) else {
            return nil
        }

        // Calculate the remaining days in the month
        let totalDaysInMonth = currentMonthRange.count
        let currentDay = calendar.component(.day, from: currentDate)
        let daysLeft = totalDaysInMonth - currentDay

        return daysLeft
    }
}


struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(presentSideMenu: .constant(false), isHomePageSelected: .constant(false))
    }
}
