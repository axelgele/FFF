//
//  ClassementModels.swift
//  ScoreAmateur
//
//  Created by Axel Gele on 25/05/2023.
//

import Foundation
struct ClassementResponse: Codable {
    let hydraMember: [ClassementEntity]
    
    enum CodingKeys: String, CodingKey {
        case hydraMember = "hydra:member"
    }
}

struct ClassementEntity: Codable, Identifiable {
    var id = UUID()
    let pointCount: Int
    let penaltyPointCount: Int
    let wonGamesCount: Int
    let drawGamesCount: Int
    let lostGamesCount: Int
    let rank: Int
    let equipe: Equipe
    let goalsDiff: Int
    let totalGamesCount: Int
    
    
    enum CodingKeys: String, CodingKey {
        case pointCount = "point_count"
        case penaltyPointCount = "penalty_point_count"
        case wonGamesCount = "won_games_count"
        case drawGamesCount = "draw_games_count"
        case lostGamesCount = "lost_games_count"
        case rank
        case equipe
        case goalsDiff = "goals_diff"
        case totalGamesCount = "total_games_count"
    }
}

struct Equipe: Codable {
    let shortName: String
    
    enum CodingKeys: String, CodingKey {
        case shortName = "short_name"
    }
}
