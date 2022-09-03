//
//  SampleApp.swift
//  Sample
//
//  Created by rucinsky on 03.09.22.
//

import SwiftUI

@main
struct SampleApp: App {
    var body: some Scene {
        WindowGroup {
            ProductListView()
                .withErrorHandling()
        }
    }
}
