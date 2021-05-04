//
//  StocksInteraсtor.swift
//  Stocks
//
//  Created by Konstantin on 04.05.2021.
//

import Foundation

class StocksInteractor {
    
    var stocks: Stocks?
    
    weak var presenter: StocksPresenter?

    init() {
        createModel()
    }
    
    func updateImage(with symbol: String) {
        NetworkService.shared.getImageUrl(symbol: symbol) { image in
            self.presenter?.setup(image)
        }
    }
    
    private func createModel() {
        NetworkService.shared.loadCompanies { [weak self] (stocks, error) in
            guard let self = self, let stocks = stocks else { return }
            if error != nil {
                self.presenter?.showNetworkError()
                Log.n(error?.localizedDescription ?? "")
            }
            self.stocks = stocks
            self.updateImage(with: stocks.compactMap({$0}).first?.symbol ?? "")
            self.presenter?.updateInterfaceIfNeded()
        }
    }
}
