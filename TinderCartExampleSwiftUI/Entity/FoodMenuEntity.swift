//
//  FoodMenuEntity.swift
//  TinderCartExampleSwiftUI
//
//  Created by 酒井文也 on 2025/01/31.
//

import Foundation

struct FoodMenuEntity: Hashable, Decodable {

    // MARK: - Property

    let id: Int
    let name: String
    let caregory: String
    let imageName: String

    // MARK: - Initializer

    init(
        id: Int,
        name: String,
        caregory: String,
        imageName: String
    ) {
        self.id = id
        self.name = name
        self.caregory = caregory
        self.imageName = imageName
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FoodMenuEntity, rhs: FoodMenuEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
