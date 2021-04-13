//
//  DataManager.swift
//  TestTask
//
//  Created by Stanislav Teslenko on 12.04.2021.
//

import UIKit

protocol DataManagerDelegate: class {
    func dataReady()
}

class DataManager {
    
    static let shared = DataManager()
    
    private let networkManager = NetworkManager()
    private let imageManager = ImageManager()
    
    weak var delegate: DataManagerDelegate?
    
    var cellModel: [CellModel] = []
    
    private init() {}
    
    // Load first news page (cell model array will be cleared)
    func loadFirstPage() {
        self.cellModel = []
        networkManager.loadData(from: .firstPage) { (newsModel) in
            self.processData(from: newsModel)
            self.delegate?.dataReady()
        }
    }
    
    // Load next news pages (new data will be added)
    func loadNextPage() {
        networkManager.loadData(from: .nextPage) { (newsModel) in
            self.processData(from: newsModel)
            self.delegate?.dataReady()
        }
    }
    
    // Select new country and/or news category and reload all data
    func reloadData(from country: String, category: String) {
        networkManager.setRequestParameters(country: country, category: category)
        loadFirstPage()
    }
    
    // Get request parameters from network manager
    func getRequestParameters() -> (country: String, category: String) {
        return networkManager.getRequestParameters()
    }
    
    // MARK: - Private functions
    
    // Create cell model array from network data
    private func processData(from model: HotNewsModel?) {
        
        guard let articles = model?.articles else {return}
        
        articles.forEach({ (article) in
            let image = self.imageManager.getImage(from: article.urlToImage) ?? #imageLiteral(resourceName: "placeholder")
            let cell = CellModel(source: article.source?.name, author: article.author, title: article.title, description: article.description, image: image, url: article.url)
            self.cellModel.append(cell)
        })
    }
    
}
