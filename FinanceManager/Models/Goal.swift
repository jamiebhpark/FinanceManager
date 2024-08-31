import Foundation

struct Goal: Identifiable, Codable {
    let id: UUID
    let name: String
    let targetAmount: Double
    let currentAmount: Double
    let deadline: Date
}
