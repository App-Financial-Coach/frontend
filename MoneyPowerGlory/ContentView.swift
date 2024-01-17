import SwiftUI
import FirebaseAuth

struct ColorPalette {
    static let textColor = Color("textColor")
    static let darkPurple = Color("darkPurple")
    static let gray = Color("gray")
    static let backgroundColor = Color("backgroundColor")
    static let darkPink = Color("darkPink")
    static let softPink = Color("softPink")
}

enum AddType {
       case expense
       case income
   }


struct ContentView: View {
    @AppStorage("uid") var userID: String = ""
    @StateObject var viewModel = ViewModel()
    @State var isHomePageSelected = false
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    @State var selectedAddType: AddType = .expense
    
    
    var navigationBarItems: some View {
        HStack {
            Button(action: {
                // Handle home button action
                isHomePageSelected = true
            }) {
                Image(systemName: "house")
                    .imageScale(.large)
                    .foregroundColor(ColorPalette.textColor)
            }
            
            Spacer()
            
            Button(action: {
                // Handle gear/settings button action
                // Add your code to show settings menu here
            }) {
                Image(systemName: "gear")
                    .imageScale(.large)
                    .foregroundColor(ColorPalette.textColor)
            }
        }
        .padding()
    }
    
    var body: some View {
        if userID == "" {
            /** Call login view if the user is not logged in yet. */
            return AnyView(LoginView())
        } else {
            return AnyView(
                Group {
                    /** As the user logged in and there is a userID exist now,
                     navigate to add income/expense page -> else
                     home page is selected from there -> if */
                    if isHomePageSelected {
                        ZStack{
                            TabView(selection: $selectedSideMenuTab) {
                                HomePageView(presentSideMenu: $presentSideMenu, isHomePageSelected: $isHomePageSelected)
                                    .tag(0)
                                IncomeBreakdownView(presentSideMenu: $presentSideMenu)
                                    .tag(1)
                                ExpenseBreakdownView(presentSideMenu: $presentSideMenu)
                                    .tag(2)
                                QuestionnaireView(presentSideMenu: $presentSideMenu)
                                    .tag(3)
                                    .navigationBarTitle("Risk Tolerance Questionnaire", displayMode: .inline)
                            }
                            
                            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
                        }
                    } else {
                        VStack {
                            navigationBarItems
                            Picker("Select Type", selection: $selectedAddType) {
                                Text("Add Expense").tag(AddType.expense)
                                Text("Add Income").tag(AddType.income)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            .colorMultiply(Color("darkPink"))
                            
                            if selectedAddType == .expense {
                                AddExpenseView(isHomePageSelected: $isHomePageSelected)
                            } else {
                                AddIncomeView(isHomePageSelected: $isHomePageSelected)
                            }
                        }
                    }
                }
                .onAppear {
                    UserManager.shared.fetchUserData(userID: userID){}
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
