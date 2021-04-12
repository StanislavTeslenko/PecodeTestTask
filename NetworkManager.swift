//
//  NetworkManager.swift
//  TestTask
//
//  Created by Stanislav Teslenko on 12.04.2021.
//

import UIKit

class NetworkManager {
    
    private let APIKey = "d77f58ad0b7544e8bb6bdc47fc6ad937"
    
    private var pageNumber: Int = 1
    private var regionCode: String = "us"
    
    init() {
        // Get current phone Country Code
        let locale = Locale.current
        regionCode = locale.regionCode ?? "us"
    }
    
    enum Pages {
        case firstPage
        case nextPage
    }
    
    private func createUrl() -> URL? {
        
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/top-headlines"
        
        let queryCountry = URLQueryItem(name: "country", value: regionCode.lowercased())
        let queryPageSize = URLQueryItem(name: "pageSize", value: "10")
        let queryPage = URLQueryItem(name: "page", value: String(pageNumber))
        
        components.queryItems = [queryCountry, queryPageSize , queryPage]
        
        return components.url
    }
    
    func loadData(from page: Pages, completion: @escaping (HotNewsModel?) -> ()) {
        
        switch page {
        
        case .firstPage:
            pageNumber = 1
        case .nextPage:
            pageNumber += 1
        }

        guard let url = createUrl() else {return}
   
        var request = URLRequest(url: url)
        request.addValue(APIKey, forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request){ (data, _, _) in
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            do {
            let news = try decoder.decode(HotNewsModel.self, from: data)
                completion(news)
            } catch {
                print("Error serialization json", error)
            }
        }.resume()
    }
}
