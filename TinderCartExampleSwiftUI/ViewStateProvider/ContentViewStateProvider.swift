//
//  ContentViewStateProvider.swift
//  TinderCartExampleSwiftUI
//
//  Created by 酒井文也 on 2025/02/01.
//

import Foundation
import Observation

// MARK: - Protocol

protocol ContentViewStateProvider {
    var foodMenus: [FoodMenuEntity] { get }
    func fetchFoodMenus()
    func removeFoodMenu(id: Int)
}

@Observable
public final class ContentViewStateProviderImpl: ContentViewStateProvider {

    // MARK: - Property (Dependency)

    private let contentRepository: ContentRepository

    // MARK: - Property (Computed)

    private var _foodMenus: [FoodMenuEntity] = []

    // MARK: - Property (`@Observable`)

    var foodMenus: [FoodMenuEntity] {
        _foodMenus
    }

    // MARK: - Initializer

    init(contentRepository: ContentRepository = ContentRepositoryImpl()) {
        self.contentRepository = contentRepository
    }

    // MARK: - Function

    func fetchFoodMenus() {
        _foodMenus = contentRepository.getAll()
    }

    func removeFoodMenu(id: Int) {
        let index = id - 1
        guard let _ = _foodMenus[safe: index] else {
            return
        }
        _foodMenus.remove(at: index)
    }
}

// MARK: - Fileprivate Extension

fileprivate extension Collection {

    // MARK: - Subscript

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
