//
//  ContentView.swift
//  Balma test
//
//  Created by Axel Gele on 17/05/2023.
//
import SwiftUI
struct ContentView: View {
    @State var matchs: [MatchEntity] = []
    @State var classement: [ClassementEntity] = []
    @State var journeesNumber:Int = 1
    @State private var selectedJournee: JourneesEntity?
    @State private var defaultJournee: Int = 21
    @State private var competitons: [Compet] = []
    @State private var selectedCompetition = 397711
    let competNamesToKeep = ["U16 REGIONAL 1", "U18 REGIONAL 1", "U15 REGIONAL"]
    var body: some View {
        VStack {
            HStack {
                Picker(selection: $selectedCompetition, label: Text("Compétition")) {
                    ForEach(0..<competitons.count, id: \.self) { index in
                        Text(competitons[index].name).tag(competitons[index].cp_no)
                    }
                }.onChange(of: selectedCompetition) { value in
                    callWebService()
                }
                Picker("Sélectionner un chiffre", selection: $defaultJournee) {
                    ForEach(1...journeesNumber, id: \.self) { number in
                        Text(String(number))
                    }
                }}.onChange(of: defaultJournee) { value in
                    callWebService()
                }
                TabView {
                    VStack {
                        ForEach(matchs, id: \.id) {match in
                            HStack {
                                if let homeLogoUrl = URL(string: match.home?.club.logo ?? ""), let awayLogoUrl = URL(string: match.away?.club.logo ?? "") {
                                    AsyncImage(url: homeLogoUrl, scale: 2.0).frame(width: 80)
                                    Text(String(match.homeScore ?? 0)).frame(width: 20)
                                    Text("-")
                                    Text(String(match.awayScore ?? 0)).frame(width: 20)
                                    AsyncImage(url: awayLogoUrl, scale: 2.0).frame(width: 80)
                                }}.padding(20)
                        }
                    }.tabItem {
                        Label("Résultats", systemImage: "sportscourt.fill")
                    }
                    HStack {
                        List(classement) { team in
                            HStack {
                                Text(String(team.rank)).frame(width: 20, alignment: .leading)    .lineLimit(1)
                                    .truncationMode(.tail)
                                Text(String(team.equipe.shortName)).frame(width: 100, alignment: .leading)    .lineLimit(1)
                                    .truncationMode(.tail)
                                Text(String(team.pointCount)).frame(width: 30, alignment: .leading).lineLimit(1).bold()
                                Text(String(team.wonGamesCount)).frame(width: 30, alignment: .leading).lineLimit(1)
                                Text(String(team.drawGamesCount)).frame(width: 30, alignment: .leading).lineLimit(1)
                                Text(String(team.lostGamesCount)).frame(width: 30, alignment: .leading).lineLimit(1)
                                Text(String(team.goalsDiff)).frame(width: 50, alignment: .leading).lineLimit(1)
                            }
                        }}.onAppear{
                            callClassement()
                        }
                        .tabItem {
                        Label("Classement", systemImage: "list.number")
                    }
                }
            }
            .onAppear {
                callWebService()
                getNumberOfJournees()
                getCategories() 
            }
        }
        func callClassement() {
            guard let url = URL(string: "https://api-dofa.fff.fr/api/compets/" + String(selectedCompetition) + "/phases/1/poules/2/classement_journees?page=1") else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let classementResponse = try decoder.decode(ClassementResponse.self, from: data)
                    classement = classementResponse.hydraMember
                    
                } catch {
                    print("Erreur de décodage JSON : \(error)")
                }
            }.resume()
        }

    func callWebService() {
        print(String(selectedCompetition))
            guard let url = URL(string: "https://api-dofa.fff.fr/api/compets/" + String(selectedCompetition) + "/phases/1/poules/2/matchs?page=1&pjNo=" + String(defaultJournee)) else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let matchResponse = try decoder.decode(MatchResponse.self, from: data)
                    matchs = matchResponse.hydraMember
                } catch {
                    print("Erreur de décodage JSON : \(error)")
                }
            }.resume()
        }
    
    func getNumberOfJournees() {
        guard let url = URL(string: "https://api-dofa.fff.fr/api/compets/397711/phases/1/poules/2/poule_journees") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let journeesResponse = try decoder.decode(JourneesResponse.self, from: data)
                journeesNumber = journeesResponse.hydraMember.count
            } catch {
                print("Erreur de décodage JSON : \(error)")
            }
        }.resume()
    }
    
    func getCategories() {
        guard let url = URL(string: "https://api-dofa.fff.fr/api/compets?cg_no=77&competition_type=CH&groups[]=compet_light") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                    if let competArray = jsonArray[3] as? [[String: Any]] {
                        for competDict in competArray {
                            let competData = try JSONSerialization.data(withJSONObject: competDict, options: [])
                            let compet = try decoder.decode(Compet.self, from: competData)
                            if competNamesToKeep.contains(compet.name) {
                                competitons.append(compet)
                            }
                        }} else {
                        print("L'élément à l'index 3 n'est pas un tableau de dictionnaires.")
                    }
                }
            } catch {
                print("Erreur lors de la conversion en JSON : \(error)")
            }        }.resume()
        }
}

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView().background(Color.white)
        }
    }
