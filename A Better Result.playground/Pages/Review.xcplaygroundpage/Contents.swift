/*:
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)

 ## Review
In my JSON Parsing series there is a section on retrieving and parsing JSON from an API   [JSON from API - Swift](https://youtu.be/ivFtzG8Bqkk)  The Generic function used here is created during this video.

This is just a quick review.

*/
import Foundation

func getJSON<T: Decodable>(urlString: String,
                           completion: @escaping (T?) -> Void) {
    guard let url = URL(string: urlString) else {
        return
    }
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print(error.localizedDescription)
            completion(nil)
            return
        }
        guard let data = data else {
            completion(nil)
            return
        }
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            completion(nil)
            return
        }
        
        completion(decodedData)
    }.resume()
}

/*:
 ### Sample Usage
 */
let gitHubURL = "https://api.github.com/users/TwoStraws/followers"
let iTunesURL = "https://itunes.apple.com/search?term=beatles&limit=50"
/*:
GitHub Example
 */
getJSON(urlString: gitHubURL) { (followers: [GHFollower]?) in
    if let followers = followers {
        for follower in followers {
            print(follower.login)
        }
    }
}
/*:
iTunesSearch Example
 */
getJSON(urlString: iTunesURL) { (searchResults: ITunesSearch?) in
    if let searchResults = searchResults {
        for track in searchResults.results {
            print(track.trackName ?? "-")
        }
    }
}
/*:

 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */

