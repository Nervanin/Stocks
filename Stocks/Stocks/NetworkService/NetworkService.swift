//
//  Stocks.swift
//  Stocks
//
//  Created by Konstantin on 01.05.2021.
//

import UIKit

class NetworkService {
    static let shared = NetworkService()
    
    func loadCompanies(completion: @escaping (_ stock: Stocks?, _ error: Error?) -> Void) {
            let urlString = "\(Resources.path)/market/list/gainers/quote?token=\(Resources.accesToken)"
            guard let url = URL(string: urlString) else {
                completion(nil, nil)
                return
            }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil, (response as? HTTPURLResponse)?.statusCode == 200 else {
                    Log.n(Resources.HandleError.message)
                    completion(nil, error)
                    return
                }
                do{
                    let stocks = try JSONDecoder().decode(Stocks.self, from: data)
                    completion(stocks, nil)
                }
                catch {
                    Log.n(error.localizedDescription)
                    completion(nil, error)
                }
            }
            task.resume()
        }
    
    func getImageUrl(symbol: String, _ completion: @escaping (_ image: UIImage) -> Void) {
        let urlString = "\(Resources.path)/\(symbol)/logo/quote?token=\(Resources.accesToken)"
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
                Log.n(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    private func loadImage(url: String, _ completion: @escaping (_ image: UIImage) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
