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
    @State var isDataLoaded = false
    @State private var selectedFlavor: Categorie = .U16
    
    let teams = [
        TeamClassement(ranking: "PI", name: "Equipe", points: "PTS", diff: "Diff"),
        TeamClassement(ranking: "1", name: "UJS", points: "57", diff: "61"),
        TeamClassement(ranking: "2", name: "MURET", points: "43", diff: "18"),
        TeamClassement(ranking: "3", name: "BALMA", points: "40", diff: "27"),
    ]
    var body: some View {
        VStack {
            Picker("Flavor", selection: $selectedFlavor) {
                Text("U16 R1").tag(Categorie.U16)
                Text("U17 R1").tag(Categorie.U17)
                Text("U18 R1").tag(Categorie.U18)
                }
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
                        List(teams) { team in
                            HStack {
                                Text(String(team.ranking)).frame(width: 80)
                                Spacer().frame(width: 20)
                                Text(String(team.name)).frame(width: 80)
                                Spacer().frame(width: 20)
                                Text(String(team.points)).frame(width: 80)
                                Spacer().frame(width: 20)
                                Text(String(team.diff)).frame(width: 80)
                            }
                        }}.tabItem {
                        Label("Classement", systemImage: "list.number")
                    }
                }
            }
            .onAppear {
                callWebService()
            }
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
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
