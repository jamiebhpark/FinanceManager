import SwiftUI

struct GoalView: View {
    @StateObject private var viewModel = GoalViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.goals) { goal in
                VStack(alignment: .leading) {
                    Text(goal.name)
                        .font(.headline)
                    Text("Target: \(goal.targetAmount, specifier: "%.2f")")
                    Text("Current: \(goal.currentAmount, specifier: "%.2f")")
                    Text("Deadline: \(goal.deadline, formatter: DateFormatter.shortDateFormatter)")
                }
            }
            .navigationTitle("Financial Goals")
            .onAppear {
                viewModel.fetchGoals()
            }
            .alert(isPresented: .constant(viewModel.error != nil)) {
                Alert(title: Text("Error"), message: Text(viewModel.error ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
        }
    }
}
