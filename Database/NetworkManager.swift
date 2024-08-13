//
//  Network.swift
//  Cabled
//
//  Created by Theo Koester on 3/22/24.
//

import Foundation
import UIKit

class NetworkManager {
    private let cache = NSCache<NSString, UIImage>()
    static let shared = NetworkManager()
    
    let ridersURL = BASE_URL + "/riders"
    let riderStatsURL = BASE_URL + "/stats/riders"
    let parksURL = BASE_URL + "/parks"
    let scorecardURL = BASE_URL + "/scorecards"
    let contestCarriersURL = BASE_URL + "/contest/carriers"
    let riderProfileURL = BASE_URL + "/riders/profile"
    
    private init() {}
    
    // Function to fetch riderse data
    func fetchRiders() async throws -> [Rider] {
        guard let url = URL(string: ridersURL) else {
            throw RequestError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            
            // Custom date decoding strategy
            decoder.dateDecodingStrategy = .custom { decoder -> Date in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                // Fallback for secondary format
                if let date = DateFormatter.yyyyMMddTHHmmss.date(from: dateString) {
                    return date
                } else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
                }
            }
            
            return try decoder.decode(Riders.self, from: data).data
        } catch {
            print("Decoding error: \(error)")
            throw RequestError.unableToComplete
        }
    }
    
    func fetchContestCarriers() async throws -> [ContestCarrier] {
        guard let url = URL(string: contestCarriersURL) else {
            throw RequestError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddTHHmmss)
            return try decoder.decode(ContestCarriers.self, from: data).data
        } catch {
            print("Decoding elinerror: \(error)")
            throw RequestError.unableToComplete
        }
    }
    
    func fetchRiderStats(cursor: String? = nil,
                         stat_id: String? = nil,
                         rider_id: String? = nil,
                         year: Int? = nil,
                         batch_size: Int? = nil) async throws -> [RiderStat] {

        var components = URLComponents(string: riderStatsURL)

        // Prepare query items based on the provided parameters
        var queryItems: [URLQueryItem] = []
        if let cursor = cursor { queryItems.append(URLQueryItem(name: "cursor", value: cursor)) }
        if let stat_id = stat_id { queryItems.append(URLQueryItem(name: "stat_id", value: stat_id)) }
        if let rider_id = rider_id { queryItems.append(URLQueryItem(name: "rider_id", value: rider_id)) }
        if let year = year { queryItems.append(URLQueryItem(name: "year", value: "\(year)")) }
        if let batch_size = batch_size { queryItems.append(URLQueryItem(name: "batch_size", value: "\(batch_size)")) }

        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw RequestError.invalidURL
        }
        
        do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom { decoder -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)

                    
                    if let date = DateFormatter.yyyyMMddTHHmmss.date(from: dateString) {
                        return date
                    } else {
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
                    }
                }
                return try decoder.decode(RiderStats.self, from: data).data
            } catch {
                print("Error decoding JSON: \(error)")
                throw RequestError.unableToComplete
            }
        }
    
    func fetchParks() async throws -> [Park] {
        print("Fetch Parks")
        guard let url = URL(string: parksURL) else {
            throw RequestError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Parks.self, from: data).data
            
        } catch {
            print("fetchPark network manager error")
            throw RequestError.unableToComplete
        }
    }
    
    func fetchScorecards(forRiders riderIds: [String]? = nil, cursor: String? = nil) async throws -> [Scorecard] {
        var components = URLComponents(string: NetworkManager.shared.scorecardURL)
        
        var queryItems = [URLQueryItem]()

        if let riderIds = riderIds, !riderIds.isEmpty {
            for riderId in riderIds {
                queryItems.append(URLQueryItem(name: "rider_ids", value: riderId))
            }
            print("Fetching scorecards for rider IDs: \(riderIds)")
        } else {
            print("Fetching scorecards without specific rider IDs")
        }

        if let cursor = cursor {
            queryItems.append(URLQueryItem(name: "cursor", value: cursor))
            print("Using cursor for pagination: \(cursor)")
        }

        components?.queryItems = queryItems
        print("URL with query parameters: \(String(describing: components?.url))")

        guard let url = components?.url else {
            print("Invalid URL")
            throw RequestError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let jsonStr = String(data: data, encoding: .utf8) {
                print("Received JSON: \(jsonStr)")
            }
            // Continue with decoding...
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            return try decoder.decode(Scorecards.self, from: data).data
        } catch {
            print("Error fetching or decoding JSON: \(error)")
            throw RequestError.unableToComplete
        }
    }

    
    func fetchRiderProfile(riderID: String) async throws -> RiderProfile {
        let urlString = riderProfileURL + "/\(riderID)" // Adjust based on API requirement
        guard let url = URL(string: urlString) else {
            throw RequestError.invalidURL
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddTHHmmss)
            return try decoder.decode(RiderProfile.self, from: data)
        } catch {
            print("Error fetching or decoding JSON: \(error)")
            throw RequestError.unableToComplete
        }
    }


    
    func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void ) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            guard let data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension DateFormatter {
    static let yyyyMMddTHHmmss: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
}



struct RiderResponse: Decodable {
    let success: Bool
    let rider_id: String
}
