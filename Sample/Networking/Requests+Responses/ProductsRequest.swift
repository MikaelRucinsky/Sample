//
//  ProductsRequest.swift
//  Sample
//
//  Created by rucinsky on 03.09.22.
//

import Foundation

struct Product: Codable {
    
    struct Rating: Codable {
        let rate: Double
        let count: Int
    }
    
    let ident: Int
    let title: String
    let description: String
    let category: String
    let imageURL: URL
    let price: Double
    let rating: Rating

    enum CodingKeys: String, CodingKey {
        case ident = "id"
        case title
        case description
        case category
        case imageURL = "image"
        case price
        case rating
    }
    
    func priceValue() -> String {
        String(format: "%.2f", price) + " €"
    }
}

extension Resources {

    static func products(path: String) -> ProductsResource {
        ProductsResource(path: path)
    }
    
    struct ProductsResource {
        let path: String
        
        var get: Request<[Product]> {
            .getFor(path: path)
        }
    }
}
