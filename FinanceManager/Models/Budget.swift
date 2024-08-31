import Foundation

struct Budget: Identifiable, Decodable {
    let id: UUID
    let category: String
    let limit: Double
    let spent: Double
}
