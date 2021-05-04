//
//  StocksPresenter.swift
//  Stocks
//
//  Created by Konstantin on 04.05.2021.
//

import UIKit

enum PriceChange {
    case up
    case down
    case `default`
}

protocol StocksPresenter: AnyObject {
    var viewModel: StocksViewModel? { get set }
    var priceChangeEnum: PriceChange { get set }
    
    func updateInterfaceIfNeded()
    func updateImage(by row: Int) 
    
    func getStocks() -> Stocks?
    func getStock(with row: Int) -> Stock?
    func setup(_ image: UIImage)
    
    func showNetworkError()
}

class StocksPresenterImpl: StocksPresenter {
    var vc: StocksViewController?
    
    var interactor = StocksInteractor()
    var priceChangeEnum: PriceChange
    
    weak var viewModel: StocksViewModel?
    
    init() {
        self.priceChangeEnum = .default
        interactor.presenter = self
    }
    
    func getStocks() -> Stocks? {
        return interactor.stocks
    }
    
    func getStock(with row: Int) -> Stock? {
        return interactor.stocks?[row]
    }
    
    func updateInterfaceIfNeded() {
        guard let stock = interactor.stocks?.compactMap({$0}).first else { return }
        changeInStockMovements(priceChange: stock.change)
        viewModel?.updateInterface(with: stock)
    }
    
    func setup(_ image: UIImage) {
        viewModel?.setup(image)
    }
    
    func updateImage(by row: Int) {
        interactor.updateImage(with: interactor.stocks?[row].symbol ?? "")
    }
    
    func showNetworkError() {
        DispatchQueue.main.async {
            self.viewModel?.showError()
        }
    }
    
    
    private func changeInStockMovements(priceChange: Double) {
        if priceChange > 0 {
            priceChangeEnum = .up
        } else if priceChange < 0 {
            priceChangeEnum = .down
        } else {
            priceChangeEnum = .default
        }
    }

}
