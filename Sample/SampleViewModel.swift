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
    
    func loadCategories() async throws -> [Category] {
        let values = try await service.categories("/products/categories")
        return values.compactMap(Category.init(title:))
    }
    
    func filterByCategory(_ category: String) async throws -> [Product] {
        try await service.category("/products/category/\(category)")
    }
}
