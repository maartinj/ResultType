/*:
 [< Previous](@previous)           [Home](Introduction) 

 ## Fine Tuning
Improve the functionality and options of the NetworkClass

*/
import Foundation
/*:
 ### Sample URLS
gitHubURL : "https://api.github.com/users/TwoStraws/followers"
 
iTunesURL: "https://itunes.apple.com/search?term=beatles&limit=50"
 */
/*:
 #### Embed new functions
 Add specific functions for differerent API Sources within the Network Class
 
 Start with the completed one from the Result page and modify it.
 */
class Network {
    enum NetworkError: Error {
        case invalidURL, decodingError, unknownError
    }
    func getFollowers(user: String,
                      completion: @escaping (Result<[GHFollower],NetworkError>) -> Void) {
        let githubURL = "https://api.github.com/users/" + user + "/followers"
        getJSON(urlString: githubURL, completion: completion)
    }
    
    func getITunesSearch(completion: @escaping(Result<ITunesSearch,NetworkError>) -> Void) {
        let iTunesURL = "https://itunes.apple.com/search?term=beatles&limit=50"
        getJSON(urlString: iTunesURL, completion: completion)
    }
    
    func getLaunches(completion: @escaping (Result<LaunchCalendar,NetworkError>) -> Void) {
        let launchURL = "https://launchlibrary.net/1.3/launch/next/5"
        getJSON(urlString: launchURL,
                dateDecodingStrategy: .secondsSince1970,
                completion: completion)
    }
    
    func getJSON<T: Decodable>(urlString: String,
                               dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil,
                               completion: @escaping (Result<T,NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data else {
                completion(.failure(.unknownError))
                return
            }
            let decoder = JSONDecoder()
            if let dateDecodingStrategy = dateDecodingStrategy {
                decoder.dateDecodingStrategy = dateDecodingStrategy
            }
            let decodedData = try? decoder.decode(T.self, from: data)
            if decodedData == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(decodedData!))
            }
        }.resume()
    }
}
/*:
GitHub Example
 */
Network().getFollowers(user: "StewartLynch") { (result) in
    switch result {
    case .success(let followers):
        for follower in followers {
            print(follower.login)
        }
    case .failure(let error):
        print(error.localizedDescription)
    }
}
/*:
iTunesSearch Example
 */
Network().getITunesSearch { (result) in
    switch result {
    case .success(let itunessearch):
        for track in itunessearch.results {
            print(track.trackName ?? "-")
        }
    case .failure(let error):
        print(error.localizedDescription)
    }
}
/*:
 #### What about Dates?
 https://launchlibrary.net/1.3/launch/next/5
 */
/*:
 #### Get launches and dates
 */
Network().getLaunches { (result) in
    switch result {
    case .success(let launchCalendar):
        for launche in launchCalendar.launches {
            print(launche.name, launche.wsstamp)
        }
    case .failure(let error):
        print(error)
    }
}
/*:
 [< Previous](@previous)           [Home](Introduction)
 */
