//
//  HelperFunctions.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//

import Foundation
import UIKit

public func uploadImageFromNetwork(image: URL?, completion: @escaping (UIImage?) -> Void) {
    if let urlImage = image {
        let request = URLRequest(url: urlImage)
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil, let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
            
        }.resume()
    }
}

public func convertDateFromStringToCorrectString(for dateString: String?) -> String? {
    guard let dateString = dateString else { return nil }
    let dateFormatterInput = DateFormatter()
    dateFormatterInput.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    if let date = dateFormatterInput.date(from: dateString) {
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.dateFormat = "yyyy-MM-dd в H:mm:ss"
        return dateFormatterOutput.string(from: date)
    }
    return nil
}
