//
//  ImageManager.swift
//  TestTask
//
//  Created by Stanislav Teslenko on 12.04.2021.
//

import UIKit

class ImageManager {
    
    // Get image from URL
    func getImage(from imageURL: String?) -> UIImage? {
        guard let stringURL = imageURL else { return nil }
        guard let imageURL = URL(string: stringURL) else { return nil }
        guard let imageData = try? Data(contentsOf: imageURL) else { return nil }
        return UIImage(data: imageData)
    }
}
