//
//  ImageUtils.swift
//  MovieQuotes
//
//  Created by Jack Speedy on 2/1/21.
//

import UIKit
import Kingfisher

class ImageUtils {
    
    static func load(imageView: UIImageView, from url: String) {
        if let imgUrl = URL(string: url) {
            imageView.kf.setImage(with: imgUrl)
//          DispatchQueue.global().async { // Download in the background
//            do {
//              let data = try Data(contentsOf: imgUrl)
//              DispatchQueue.main.async { // Then update on main thread
//                imageView.image = UIImage(data: data)
//              }
//            } catch {
//              print("Error downloading image: \(error)")
//            }
//          }
        }
    }
    
}
