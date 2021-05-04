//
//  StockRouter.swift
//  Stocks
//
//  Created by Konstantin on 04.05.2021.
//

import UIKit

class StocksRouter {
    func showAlertController(with title: String, message: String, on controller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeApp = UIAlertAction(title: "Выйти", style: .cancel, handler: { actionAlert in
            controller.dismiss(animated: true, completion: nil)
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        })
        alertController.addAction(closeApp)
        controller.present(alertController, animated: true, completion: nil)
    }
}
