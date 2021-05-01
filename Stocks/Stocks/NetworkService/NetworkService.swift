//
//  Stocks.swift
//  Stocks
//
//  Created by Konstantin on 01.05.2021.
//

import UIKit

class NetworkService {
    static let shared = NetworkService()
    
    func loadCompanies(completion: @escaping (_ shared: Companies?, _ error: Error?) -> Void) {
            let urlString = "\(Resources.path)/market/list/gainers/quote?token=\(Resources.accesToken)"
            guard let url = URL(string: urlString) else {
                completion(nil, nil)
                return
            }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil, (response as? HTTPURLResponse)?.statusCode == 200 else {
                    print(Resources.HandleError.message)
                    completion(nil, error)
                    return
                }
                do{
                    print(data)
                    let params = try JSONDecoder().decode(Companies.self, from: data)
                    completion(params, nil)
                }
                catch {
                    print(error.localizedDescription)
                    completion(nil, error)
                }
            }
            task.resume()
        }
    
    func getImageUrl(symbol: String, _ completion: @escaping (_ shared: UIImage) -> Void) {
        let urlString = "\(Resources.path)/\(symbol)/logo/quote?token=\(Resources.accesToken)"
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // нет смысла вызывать алерт на загрузку картинки, на работу приложения не влияет. Достаточно залогировать.
            guard let data = data, error == nil, (response as? HTTPURLResponse)?.statusCode == 200 else {
                print(Resources.HandleError.message)
                return
            }
            do{
                let url = try JSONDecoder().decode(GalleryImage.self, from: data)
                self.loadImage(url: url.url) { image in
                    completion(image)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func loadImage(url: String, _ completion: @escaping (_ shared: UIImage) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // нет смысла вызывать алерт на загрузку картинки, на работу приложения не влияет.
            guard let data = data, error == nil, (response as? HTTPURLResponse)?.statusCode == 200 else {
                print(Resources.HandleError.message)
                return
            }
            guard let image = UIImage(data: data) else { return }
            completion(image)
        }
        task.resume()
    }
}
