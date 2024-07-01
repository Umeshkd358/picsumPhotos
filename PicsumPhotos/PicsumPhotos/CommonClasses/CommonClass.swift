//
//  CommonClass.swift
//  PicsumPhotos
//
//  Created by Umesh on 01/07/24.
//

import Foundation
import UIKit

class CommonClass: UIViewController {
    
   static func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Checking if the URL is valid
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // Created a URLSession data task to download the image data
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle any errors
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let imageData = data else {
                print("No data received from image URL")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: imageData) {
                completion(image)
            } else {
                print("Unable to create image from data")
                completion(nil)
            }
            
        }.resume()
    }
}
