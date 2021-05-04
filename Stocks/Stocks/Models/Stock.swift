//
//  Stock.swift
//  Company
//
//  Created by Konstantin on 01.05.2021.
//

import UIKit

struct Stock: Codable {
    let symbol, companyName: String
    let latestPrice: Double
    let change: Double
    
    var latestPriceString: String {
        return String(format: "%.2f", latestPrice)
    }
    var changeString: String {
        return String(format: "%.2f", change)
    }
   
    enum CodingKeys: String, CodingKey {
        case symbol, companyName, change, latestPrice
    }
}

typealias Stocks = [Stock]

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public func hash(into hasher: inout Hasher) { }
  
    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
