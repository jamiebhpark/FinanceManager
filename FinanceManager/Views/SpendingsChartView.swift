import SwiftUI
import Charts

struct SpendingsChartView: View {
    @StateObject private var transactionViewModel = TransactionViewModel()

    var body: some View {
        VStack {
            if transactionViewModel.transactions.isEmpty {
                Text("No Transaction Data Available")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                Chart(transactionViewModel.transactions) { transaction in
                    LineMark(
                        x: .value("Date", transaction.date),
                        y: .value("Amount", transaction.amount)
                    )
                    .foregroundStyle(.red)
                }
                .frame(height: 300)
                .padding()
                .navigationTitle("Spending Over Time")
            }
        }
        .onAppear {
            transactionViewModel.fetchTransactions()
        }
        .alert(isPresented: .constant(transactionViewModel.error != nil)) {
            Alert(
                title: Text("Error"),
                message: Text(transactionViewModel.error ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct SpendingsChartView_Previews: PreviewProvider {
    static var previews: some View {
        SpendingsChartView()
    }
}
