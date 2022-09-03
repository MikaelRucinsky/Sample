//
//  SampleViewModel.swift
//  Sample
//
//  Created by rucinsky on 03.09.22.
//

import Foundation

struct Category: Identifiable {
    let id = UUID()
    let title: String
    let isSelected: Bool
}

final class SampleViewModel: ObservableObject {
    
    private var environment: URL
    
    private lazy var client: APIClient = {
        APIClient(environment: environment)
    }()
    
    private lazy var service: SampleService = {
        SampleService(client: client)
    }()
    
    init(environment: URL) {
        self.environment = environment
    }
    
    func loadProducts() async throws -> [Product] {
        try await service.products("/products")
    }
    
    func loadProductDetailFor(_ id: Int) async throws -> Product {
        try await service.productDetail("/products/\(id)")
    }
    
    func loadCategoriesWithFilter(_ title: String) async throws -> [Category] {
        var values = try await service.categories("/products/categories")
        values.move(title, to: 0)
        let c = values.map( { Category.init(title: $0, isSelected: $0 == title) })
        return c
    }
    
    func filterByCategory(_ category: String) async throws -> [Product] {
        try await service.category("/products/category/\(category)")
    }
}
