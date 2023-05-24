//
//  ContentView.swift
//  Balma test
//
//  Created by Axel Gele on 17/05/2023.
//

import SwiftUI
var matchs: [MatchEntity] = []

struct ContentView: View {
    var imageUrl = URL(string: "https://www.example.com/image.jpg")
    var body: some View {
        VStack {
            ForEach(matchs, id: \.self) { match in
//                AsyncImage(url: URL(string: match.home.club.logo ?? "")) { phase in
//                    phase.image
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
                print(matchs)
                }
                .frame(width: 100, height: 100)
                // Additional view modifiers or content for each match's image
            }.padding()
        .onAppear {
            callWebService()
        }
    }
}

func callWebService() {
    guard let url = URL(string: "https://api-dofa.fff.fr/api/compets/397711/phases/1/poules/2/resultat?page=1") else {
        return
    }

    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            return
        }

        do {
            let decoder = JSONDecoder()
            let matchResponse = try decoder.decode(MatchResponse.self, from: data)
            // Utilisez l'objet matchResponse comme vous le souhaitez
            // Par exemple, vous pouvez accéder aux éléments de matchs comme suit :
            let matches = matchResponse.hydraMember
            for match in matches {
                matchs.append(match)
            }
        } catch {
            print("Erreur de décodage JSON : \(error)")
        }
    }.resume()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
