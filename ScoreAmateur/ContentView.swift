//
//  ContentView.swift
//  Balma test
//
//  Created by Axel Gele on 17/05/2023.
//
enum Categorie: String, CaseIterable, Identifiable {
    case U17, U16, U18
    var id: Self { self }
}

struct TeamClassement: Identifiable {
    let id = UUID()
    let ranking: String
    let name: String
    let points: String
    let diff: String
}

import SwiftUI
struct ContentView: View {
    @State var matchs: [MatchEntity] = []
    @State var classement: [ClassementEntity] = []
    @State var journeesList: [JourneesEntity] = []
    @State var isDataLoaded = false
    @State private var selectedFlavor: Categorie = .U16
    let journee : JourneesEntity
    @State private var selectedJournee: JourneesEntity? = JourneesEntity(id: UUID(), name: "21")

    init() {
        journee = JourneesEntity(id: UUID(), name: "Nom de la journée")
    }
    var body: some View {
        VStack {
            HStack {

                Picker("Categories", selection: $selectedFlavor) {
                    Text("U16 R1").tag(Categorie.U16)
                    Text("U17 R1").tag(Categorie.U17)
                    Text("U18 R1").tag(Categorie.U18)
                }.pickerStyle(.menu)
                Picker("Journées", selection: $selectedJournee) {
                    ForEach(journeesList, id: \.id) { journee in
                        Text(journee.name)
                        }
                        }
                    }.pickerStyle(.menu)
            
                TabView {
                    VStack{
                        ForEach(matchs, id: \.id) { match in
                            HStack {
                                AsyncImage(url: URL(string: match.home.club.logo), scale: 2.0).frame(width: 80)
                                Text(String(match.homeScore)).frame(width: 20)
                                Text("-")
                                Text(String(match.awayScore)).frame(width: 20)
                                AsyncImage(url: URL(string: match.away.club.logo), scale: 2.0).frame(width: 80)
                            }.padding(20)
                        }
                        
                    }.tabItem {
                        Label("Résultats", systemImage: "sportscourt.fill")
                    }
                    
                    HStack{
                        List(classement) { team in
                            HStack {
                                Text(String(team.rank)).frame(width: 20, alignment: .leading)    .lineLimit(1)
                                    .truncationMode(.tail)
                                Text(String(team.equipe.shortName)).frame(width: 90, alignment: .leading)    .lineLimit(1)
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
            }
        }
        
        func callClassement() {
            guard let url = URL(string: "https://api-dofa.fff.fr/api/compets/397711/phases/1/poules/2/classement_journees?page=1") else {
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
            guard let url = URL(string: "https://api-dofa.fff.fr/api/compets/397711/phases/1/poules/2/matchs?page=1&pjNo=21") else {
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
                    journeesList = journeesResponse.hydraMember
                    print(journeesList)
                } catch {
                    print("Erreur de décodage JSON : \(error)")
                }
            }.resume()
        }

        
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
