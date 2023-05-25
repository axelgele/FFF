//
//  JourneeModels.swift
//  ScoreAmateur
//
//  Created by Axel Gele on 25/05/2023.
//

import Foundation
struct JourneesResponse: Codable, Identifiable {
    var id = UUID()
    let hydraMember: [JourneesEntity]
    let hydraTotalItems: Int
    
    enum CodingKeys: String, CodingKey {
        case hydraMember = "hydra:member"
        case hydraTotalItems = "hydra:totalItems"
    }
}

struct JourneesEntity: Codable, Hashable {
    var id = UUID()
    let name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: JourneesEntity, rhs: JourneesEntity) -> Bool {
        return lhs.id == rhs.id
    }
    enum CodingKeys: String, CodingKey {
        case name
    }
}
