import Foundation
import Combine

class BudgetViewModel: ObservableObject {
    @Published var budgets: [Budget] = []
    @Published var error: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchBudgets()
    }

    func fetchBudgets() {
        NetworkManager.shared.request("/budgets", method: .get)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error.localizedDescription
                    print("Error fetching budgets: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] budgets in
                self?.budgets = budgets
            })
            .store(in: &cancellables)
    }
}
