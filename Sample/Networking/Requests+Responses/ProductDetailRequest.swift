//
//  ProductDetail.swift
//  Sample
//
//  Created by rucinsky on 03.09.22.
//

import Foundation

extension Resources {

    static func productDetail(path: String) -> ProductDetailResource {
        ProductDetailResource(path: path)
    }

    struct ProductDetailResource {
        let path: String

        var get: Request<Product> {
            .getFor(path: path)
        }
    }
}
