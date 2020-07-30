//
//  MainAPI.swift
//  YOKE HomeScreen
//
//  Created by Jorge Daboub on 7/29/20.
//  Copyright © 2020 Jorge Daboub. All rights reserved.
//

import Foundation

// MARK: - homeResponse
public struct homeResponse: Codable {
    var stars: [Star]
    var onlineStars: [Star]?
    
    init() {
        self.stars = [Star()]
        self.onlineStars = [Star()]
    }
}

// MARK: - Star
public struct Star: Codable {
    let name, bio: String
    let isOnline: Bool
    var isFollowing: Bool?
    
    init() {
        self.name = ""
        self.bio = ""
        self.isOnline = false
        self.isFollowing = false
    }
    init(name: String){
        self.name = name
        self.bio = ""
        self.isOnline = false
    }
}

// MARK: - Class Declaration
class homeData: ObservableObject {
    /* API Class to fetch data */
    @Published var data = homeResponse()
    
    // URL to Call
    let baseURL = URL(string: "https://us-central1-yoke-gaming.cloudfunctions.net/testCall")!
    
    init() {
        self.fetch()
    }
    
    func fetch() {
        var request = URLRequest(url: self.baseURL)
        
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error:  \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("HTTP Status code: \(response.statusCode)")
            }
            
            // Decode Response
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let decodedData = try? jsonDecoder.decode(homeResponse.self,
                                                          from: data) {
                DispatchQueue.main.async {
                    self.data = decodedData
                    
                    // Sort Online players
                    self.data.onlineStars = [Star(name: "No Players Online")]
                    for star in self.data.stars {
                        if star.isOnline{
                            self.data.onlineStars?.append(star)
                        }
                    }
                    if self.data.onlineStars!.count > 1 {
                        self.data.onlineStars?.remove(at: 0)
                    }
                    print(self.data)
                }
            }
        }
        task.resume()
    }
}
