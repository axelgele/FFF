import Foundation
struct Group: Decodable {
    var id: String?
    var name: String
    var stageNumber: Int

    enum CodingKeys: String, CodingKey {
        case id = "@id"
        case name
        case stageNumber = "stage_number"
    }
}
struct Phase: Decodable {
    var id: String
    var type: String
    var groups: [Group]
    var name: String
    var number: Int

    enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
        case groups
        case name
        case number
    }
}
struct Compet: Decodable {
    var id: String
    var type: String
    var cp_no: Int
    var name: String
    var phases: [Phase]
    enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
        case cp_no
        case name
        case phases
    }
}
