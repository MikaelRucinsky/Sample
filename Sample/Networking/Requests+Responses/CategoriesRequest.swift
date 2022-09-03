//
//  CategoriesRequest.swift
//  Sample
//
//  Created by rucinsky on 03.09.22.
//

import Foundation

extension Resources {

    static func categories(path: String) -> CategoriesResource {
        CategoriesResource(path: path)
    }
    
    struct CategoriesResource {
        let path: String
        
        var get: Request<[String]> {
            .getFor(path: path)
        }
    }
}
