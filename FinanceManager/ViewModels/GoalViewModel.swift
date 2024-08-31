import Foundation
import Alamofire
import Combine

class GoalViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var error: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchGoals()
    }

    func fetchGoals() {
        NetworkManager.shared.request("/goals", method: .get)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error.localizedDescription
                    print("Error fetching goals: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] goals in
                self?.goals = goals
            })
            .store(in: &cancellables)
    }

    func addGoal(goal: Goal) {
        guard let body = try? JSONEncoder().encode(goal) else { return }
        
        NetworkManager.shared.request("/goals", method: .post, body: body)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = "Failed to add goal: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] (newGoal: Goal) in
                self?.goals.append(newGoal)
            })
            .store(in: &cancellables)
    }

    func updateGoal(goal: Goal) {
        guard let body = try? JSONEncoder().encode(goal) else { return }

        NetworkManager.shared.request("/goals/\(goal.id.uuidString)", method: .put, body: body)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = "Failed to update goal: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] (updatedGoal: Goal) in
                if let index = self?.goals.firstIndex(where: { $0.id == updatedGoal.id }) {
                    self?.goals[index] = updatedGoal
                }
            })
            .store(in: &cancellables)
    }

    func deleteGoal(goalID: UUID) {
        NetworkManager.shared.request("/goals/\(goalID.uuidString)", method: .delete)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = "Failed to delete goal: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] (_: EmptyResponse) in
                self?.goals.removeAll { $0.id == goalID }
            })
            .store(in: &cancellables)
    }
}
