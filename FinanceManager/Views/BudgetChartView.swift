import SwiftUI
import Charts

struct BudgetChartView: View {
    @StateObject private var viewModel = BudgetViewModel()

    var body: some View {
        VStack {
            if viewModel.budgets.isEmpty {
                Text("No Budget Data Available")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                Chart(viewModel.budgets) { budget in
                    BarMark(
                        x: .value("Category", budget.category),
                        y: .value("Spent", budget.spent)
                    )
                    .foregroundStyle(.blue)
                }
                .frame(height: 300)
                .padding()
                .navigationTitle("Budgets")
            }
        }
        .onAppear {
            viewModel.fetchBudgets()
        }
        .alert(isPresented: .constant(viewModel.error != nil)) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct BudgetChartView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetChartView()
    }
}
