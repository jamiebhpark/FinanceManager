import Foundation

struct Transaction: Identifiable, Decodable {
    let id: UUID
    let description: String
    let amount: Double
    let date: Date
}
