import SwiftUI
import UIKit

/*
class ViewModel: ObservableObject {
    @Published var isCategorySelection: Bool = false
    @Published var selectedCategory: ExpenseCategory?
}
*/
/*
 Call categories stack for each subcategory
 This function will add the subcategory below the title of main category
 */
struct AddExpenseSubCategories: View {
    
    let category: ExpenseCategory

    var body: some View {
        VStack {
            Image(systemName: category.systemImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(Color(category.color))

            Text(category.name)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
        .padding()
    }
}

/*
 Call categories stack for each subcategory
 This function will add the subcategory below the title of main category
 */
struct ExpenseCategoriesListView: View {
    @EnvironmentObject var viewModel: ViewModel
    var parentCategory: String
    var subcategories: [ExpenseCategory]
    
    var body: some View {
        Spacer()
        Text(parentCategory)
            .font(.title2)
            .padding(.leading)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {

                ForEach(subcategories.indices, id: \.self) { index in
                    Button(action: {
                        // assign the selected subcategory
                        viewModel.selectedCategory = self.subcategories[index]
                        viewModel.isCategorySelection = false
                    }) {
                        VStack {
                            Image(systemName: subcategories[index].systemImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color(subcategories[index].color))
                            
                            Text(subcategories[index].name)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                                .foregroundStyle(.black)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}


/*
 struct ExpenseCategoriesListView: View {
     let parentCategory: String
     let subcategories: [ExpenseCategory]

     var body: some View {
         VStack(alignment: .leading) {
             Spacer()
             Text(parentCategory)
                 .font(.title2)
                 .padding(.leading)

             ScrollView(.horizontal, showsIndicators: false) {
                 HStack(spacing: 8) {
                     ForEach(subcategories.filter { $0.parentCategory == parentCategory }, id: \.name) { subcategory in
                         AddExpenseSubCategories(category: subcategory)
                        }
                 }
                 .padding(.horizontal)
             }
         }
     }
 }

 */
struct ExpenseCategoriesView: View {

    var body: some View {
        ScrollView {
            let selectedParentCategories: [String] = Array(Set(ExpenseCategories.allCategories.compactMap { $0.parentCategory }))
            ForEach(selectedParentCategories, id: \.self) { parentCategory in
                   let subcategories = ExpenseCategories.allCategories.filter { $0.parentCategory == parentCategory }
                ExpenseCategoriesListView(parentCategory: parentCategory, subcategories: subcategories)
                       .padding(.bottom, 10)
             }
        }
    }
}

