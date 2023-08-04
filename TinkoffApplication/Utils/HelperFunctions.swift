//
//  HelperFunctions.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//

import Foundation
import UIKit


public func uploadImageFromNetwork(image: URL?, completion: @escaping (Result<UIImage, URLError>) -> Void) {
    guard let url = image else {
        completion(.failure(URLError(.badURL)))
        return
    }
    DispatchQueue.global(qos: .utility).async {
        do {
            let data = try Data(contentsOf: url)
            DispatchQueue.main.async {
                if let uiimage = UIImage(data: data) {
                    completion(.success(uiimage))
                } else {
                    completion(.failure(URLError(.cannotLoadFromNetwork)))
                }
            }
            
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error as! URLError))
            }
        }
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
