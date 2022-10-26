/*:
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 
 ## User Result
 Improve the Service Class by changing the completion to use a Result type.
 */
import Foundation
/*:
 ## Build Service Class
 */
class Network {
    enum NetworkError: Error {
        case invalidURL, decodingError, unknownError
    }
    func getJSON<T: Decodable>(urlString: String,
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
 ### Sample Usage
 */
let gitHubURL = "https://api.github.com/users/TwoStraws/followers"
let iTunesURL = "https://itunes.apple.com/search?term=beatles&limit=50"

/*:
GitHub Example
 */
Network().getJSON(urlString: gitHubURL) { (result: Result<[GHFollower],Network.NetworkError>) in
    switch result {
    case .success(let followers):
        for follower in followers {
//            print(follower.login)
        }
    case .failure(let error):
        print(error, error.localizedDescription)
    }
}
/*:
iTunesSearch Example
 */
Network().getJSON(urlString: iTunesURL) { (result: Result<ITunesSearch,Network.NetworkError>) in
    switch result {
    case .success(let itunessearch):
        for track in itunessearch.results {
            print(track.trackName ?? "-")
        }
    case .failure(let error):
        print(error)
    }
}
/*:
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */
