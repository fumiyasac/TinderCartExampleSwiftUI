//
//  ContentRepository.swift
//  TinderCartExampleSwiftUI
//
//  Created by 酒井文也 on 2025/02/01.
//

import Foundation

protocol ContentRepository {
    func getAll() -> [FoodMenuEntity]
}

final class ContentRepositoryImpl: ContentRepository {

    // MARK: - Function

    func getAll() -> [FoodMenuEntity] {
        return [
            FoodMenuEntity(
                id: 1,
                name: "熱々エビグラタン",
                caregory: "洋風・オーブン料理",
                imageName: "food_example1"
            ),
            FoodMenuEntity(
                id: 2,
                name: "海鮮入り寄せ鍋",
                caregory: "和風・鍋料理",
                imageName: "food_example2"
            ),
            FoodMenuEntity(
                id: 3,
                name: "赤身肉のすき焼き",
                caregory: "和風・鍋料理",
                imageName: "food_example3"
            ),
            FoodMenuEntity(
                id: 4,
                name: "カツオのたたき",
                caregory: "和風・刺身",
                imageName: "food_example4"
            ),
            FoodMenuEntity(
                id: 5,
                name: "本日のおすすめ3種盛合せ",
                caregory: "和風・刺身",
                imageName: "food_example5"
            ),
            FoodMenuEntity(
                id: 6,
                name: "天津飯",
                caregory: "中華風・ご飯もの",
                imageName: "food_example6"
            ),
            FoodMenuEntity(
                id: 7,
                name: "山菜炊き込みご飯",
                caregory: "和風・ご飯もの",
                imageName: "food_example7"
            ),
            FoodMenuEntity(
                id: 8,
                name: "おでん",
                caregory: "和風・鍋料理",
                imageName: "food_example8"
            ),
            FoodMenuEntity(
                id: 9,
                name: "鯖の味噌煮",
                caregory: "和風・煮込み料理",
                imageName: "food_example9"
            ),
            FoodMenuEntity(
                id: 10,
                name: "鶏鍋",
                caregory: "和風・鍋料理",
                imageName: "food_example10"
            ),
            FoodMenuEntity(
                id: 11,
                name: "海鮮チヂミ",
                caregory: "韓国風・お好み焼き",
                imageName: "food_example11"
            ),
            FoodMenuEntity(
                id: 12,
                name: "きのこ炊き込みご飯",
                caregory: "和風・ご飯もの",
                imageName: "food_example12"
            )
        ]
    }
}
