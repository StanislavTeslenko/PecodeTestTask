//
//  NetworkManager.swift
//  TestTask
//
//  Created by Stanislav Teslenko on 12.04.2021.
//

import UIKit

class NetworkManager {
    
    //Another keys - "d77f58ad0b7544e8bb6bdc47fc6ad937", "9a0f08d7c34f42e387fea43ef812959e"
    private let APIKey = "fadc0496436e42c49ef67819d731ecfc"
    
    private var pageNumber: Int = 1
    private var regionCode: String = "us"
    private var category: String = "general"
    
    init() {
        // Get current phone Country Code
        let locale = Locale.current
        regionCode = locale.regionCode?.lowercased() ?? "us"
    }
    
    enum Pages {
        case firstPage
        case nextPage
    }
    
    // Store request parameters
    func setRequestParameters(country: String, category: String) {
        self.regionCode = country
        self.category = category
    }
    
    // Get request parameters
    func getRequestParameters() -> (country: String, category: String) {
        return (regionCode, category)
    }
    
    // Create URL from components
    private func createUrl() -> URL? {
        
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/top-headlines"
        
        let queryCountry = URLQueryItem(name: "country", value: regionCode)
        let queryCathegory = URLQueryItem(name: "category", value: category)
        let queryPageSize = URLQueryItem(name: "pageSize", value: "10")
        let queryPage = URLQueryItem(name: "page", value: String(pageNumber))
        
        components.queryItems = [queryCountry, queryCathegory, queryPageSize , queryPage]
        
        return components.url
    }
    
    // Send GET network request and decode data
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
