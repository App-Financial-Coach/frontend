import Foundation

enum SideMenuRowType: Int, CaseIterable{
    case home = 0
    case IncomeBreakdown
    case ExpenseBreakdown
    case Questionnaire
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .IncomeBreakdown:
            return "Income Breakdown"
        case .ExpenseBreakdown:
            return "Expense Breakdown"
        case .Questionnaire:
            return "Questionnaire"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "house.fill"
        case .IncomeBreakdown:
            return "square.and.arrow.down"
        case .ExpenseBreakdown:
            return "square.and.arrow.up"
        case .Questionnaire:
            return "questionmark.square.dashed"
        }
    }
}
