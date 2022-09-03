//
//  SampleService.swift
//  Sample
//
//  Created by rucinsky on 03.09.22.
//

import Foundation

struct SampleService {
    
    private var client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func products(_ path: String) async throws -> [Product] {
        try await client.value(for: Resources.products(path: path).get)
    }
    
    func productDetail(_ path: String) async throws -> Product {
        try await client.value(for: Resources.productDetail(path: path).get)
    }
    
    func categories(_ path: String) async throws -> [String] {
        try await client.value(for: Resources.categories(path: path).get)
    }
    
    func category(_ path: String) async throws -> [Product] {
        try await client.value(for: Resources.products(path: path).get)
    }
}
