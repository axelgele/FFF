//
//  MatchModels.swift
//  ScoreAmateur
//
//  Created by Axel Gele on 24/05/2023.
//

import Foundation

struct MatchResponse: Codable {
    let hydraMember: [MatchEntity]
    
    enum CodingKeys: String, CodingKey {
        case hydraMember = "hydra:member"
    }
}

struct MatchEntity: Codable, Identifiable  {
    var id = UUID()
    let type: String
    let pouleJournee: PouleJournee
    let home: Team
    let away: Team
    let date: String
    let time: String
    let homeResu: String
    let homeScore: Int
    let homeIsForfeit: String
    let awayResu: String
    let awayScore: Int
    let awayIsForfeit: String
    let seemsPostponed: String
    
    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case pouleJournee = "poule_journee"
        case home, away
        case date, time
        case homeResu = "home_resu"
        case homeScore = "home_score"
        case homeIsForfeit = "home_is_forfeit"
        case awayResu = "away_resu"
        case awayScore = "away_score"
        case awayIsForfeit = "away_is_forfeit"
        case seemsPostponed = "seems_postponed"
    }
}

struct PouleJournee: Codable {
    let number: Int
}

struct Team: Codable {
    let club: Club
    let short_name: String
    
    enum CodingKeys: String, CodingKey {
        case club, short_name = "short_name"
    }
}

struct Club: Codable {
    let logo: String
}
