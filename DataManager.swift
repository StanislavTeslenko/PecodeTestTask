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
    
    func loadFirstPage() {
        self.cellModel = []
        networkManager.loadData(from: .firstPage) { (newsModel) in
            self.processData(from: newsModel)
            self.delegate?.dataReady()
        }
    }
    
    func loadNextPage() {
        networkManager.loadData(from: .nextPage) { (newsModel) in
            self.processData(from: newsModel)
            self.delegate?.dataReady()
        }
    }
    
    func reloadData(from country: String, category: String) {
        networkManager.setRequestParameters(country: country, category: category)
        loadFirstPage()
    }
    
    func getRequestParameters() -> (country: String, category: String) {
        return networkManager.getRequestParameters()
    }
    
    private func processData(from model: HotNewsModel?) {
        
        guard let articles = model?.articles else {return}
        
        articles.forEach({ (article) in
            let image = self.imageManager.getImage(from: article.urlToImage) ?? #imageLiteral(resourceName: "placeholder")
            let cell = CellModel(source: article.source?.name, author: article.author, title: article.title, description: article.description, image: image, url: article.url)
            self.cellModel.append(cell)
        })
    }
    
}
