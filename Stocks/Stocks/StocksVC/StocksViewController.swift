//
//  ViewController.swift
//  Stocks
//
//  Created by Konstantin on 01.05.2021.
//

import UIKit

protocol StocksViewModel: AnyObject {
    func updateInterface(with stock: Stock)
    func setup(_ image: UIImage)
    
    func showError()
}

class StocksViewController: UIViewController, StocksViewModel {
    
    @IBOutlet var companyImageView: UIImageView!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var priceChangLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var changeStocksImageView: UIImageView!
    @IBOutlet var loaderView: UIActivityIndicatorView!
    
    var presenter: StocksPresenter = StocksPresenterImpl()
    var router = StocksRouter()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewModel = self
    }
    
    func updateInterface(with stock: Stock) {
        setupInterface(with: stock)
    }
    
    private func setupInterface(with stock: Stock) {
        DispatchQueue.main.async {
            self.companyNameLabel.text = stock.companyName
            self.symbolLabel.text = stock.symbol
            self.priceChangLabel.text = stock.changeString
            self.priceLabel.text = stock.latestPriceString
            
            switch self.presenter.priceChangeEnum {
            case .up:
                self.changeStocksImageView.image = UIImage(systemName: GalleryImage.upImage)
                self.priceChangLabel.textColor = Colors.green
            case .down:
                self.changeStocksImageView.image = UIImage(systemName: GalleryImage.downImage)
                self.priceChangLabel.textColor = Colors.red
            case .default:
                self.priceChangLabel.textColor = Colors.white
            }
            self.loaderView.isHidden = true
            self.pickerView.reloadAllComponents()
        }
    }
    
    func setup(_ image: UIImage) {
        DispatchQueue.main.async {
            self.companyImageView.image = image
        }
    }
    
    func showError() {
        router.showAlertController(with: Constants.errorTitle, message: Constants.errorMessage, on: self)
    }
}

extension StocksViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let stocksCount = presenter.getStocks()?.count else { return 0 }
        return stocksCount
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let stock = presenter.getStock(with: row) else { return }
        setupInterface(with: stock)
        presenter.updateImage(by: row)
    }
}

extension StocksViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let stock = presenter.getStock(with: row) else { return nil }
        return stock.companyName
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let stock = presenter.getStock(with: row) else { return nil }
        return NSAttributedString(string: stock.companyName, attributes: [NSAttributedString.Key.foregroundColor: Colors.white])
    }
}


