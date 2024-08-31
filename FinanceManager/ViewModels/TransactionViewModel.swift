import Foundation
import Combine

class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var error: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchTransactions()
    }

    func fetchTransactions() {
        NetworkManager.shared.request("/transactions", method: .get)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error.localizedDescription
                    print("Error fetching transactions: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] transactions in
                self?.transactions = transactions
            })
            .store(in: &cancellables)
    }
}
