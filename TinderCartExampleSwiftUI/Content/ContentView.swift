//
//  ContentView.swift
//  TinderCartExampleSwiftUI
//
//  Created by 酒井文也 on 2025/01/30.
//

import SwiftUI

// Tinderの様な動きをSwiftUIを利用して実現する
// 参考: https://github.com/bbaars/SwiftUI-Tinder-SwipeableCards

struct ContentView: View {

    // MARK: - ViewStateProvider

    private var contentViewStateProvider: ContentViewStateProvider

    // MARK: - Initializer

    init() {
        // ContentViewStateProviderの初期化する
        contentViewStateProvider = ContentViewStateProviderImpl()
    }

    // MARK: - Body

    var body: some View {

        NavigationStack {
            VStack {
                // ① タイトルヘッダー表示
                VStack {
                    Text("⭐️今日の気分に合う献立を選ぼう⭐️")
                        .font(.body)
                        .bold()
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    VStack(alignment: .leading) {
                        Text("今日の献立はどうしようか...🧐そんな時は気軽に写真と今日の気分にピッタリなものを選んでサッと決めてしまうのも良いでしょう🍽️")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .padding(.top, 8.0)
                            .padding(.horizontal, 8.0)
                    }
                }
                .padding(.top, 16.0)
                .padding(.horizontal, 8.0)

                // ②-1. 画面上にカードが1枚も存在しない場合は、再度配置をするボタンを配置する
                if contentViewStateProvider.foodMenus.isEmpty {

                    HStack {
                        Spacer()
                        Button(action: {
                            contentViewStateProvider.fetchFoodMenus()
                        }, label: {
                            Text("再度献立カードの一覧を表示する")
                                .font(.body)
                                .foregroundColor(.black)
                                .background(.white)
                                .frame(width: 280.0, height: 48.0)
                                .cornerRadius(24.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24.0)
                                        .stroke(Color(.black), lineWidth: 1.0)
                                )
                        })
                        Spacer()
                    }
                    .padding(.vertical, 16.0)
                
                // ②-2. 画面上にカードが少なくとも1枚存在する場合は、カードを重ねる様に表示する
                } else {

                    // GeometryReaderを利用して、デバイス幅を元に要素配置に必要な値を算出する
                    GeometryReader { proxy in
                        // 👉 1つあたりの表示要素を重ねるためにZStackを用いる
                        ZStack {
                            ForEach(contentViewStateProvider.foodMenus, id: \.self) { foodMenuEntity in
                                Group {
                                    // 取得できたデータの順番にカード用View要素を重ねて配置する
                                    SwipableCardView(foodMenuEntity: foodMenuEntity, removeAction: { removeTargetFoodMenuEntity in
                                        contentViewStateProvider.removeFoodMenu(id: removeTargetFoodMenuEntity.id)
                                    })
                                    .animation(.spring, value: contentViewStateProvider.foodMenus)
                                    .frame(width: getCardWidth(proxy: proxy, id: foodMenuEntity.id), height: 350.0)
                                    .offset(x: 16.0, y: getCardOffset(proxy: proxy, id: foodMenuEntity.id))
                                }
                            }
                        }
                    }
                    .padding(.top, 16.0)
                }
 
                // ③ 上寄せにするためのSpacer
                Spacer()
            }
            .onFirstAppear {
                contentViewStateProvider.fetchFoodMenus()
            }
            .navigationBarTitle("Today's Dinner Selection")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Private Function

    // スワイプできるカード要素の幅を算出する
    // 👉 SwipableCardView ~ .frameの箇所でこの計算値を利用しています
    private func getCardWidth(proxy: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = getCardOffset(proxy: proxy, id: id)
        let originCardWidth: CGFloat = proxy.size.width - 36.0
        // 👉 負数になってはいけないWarningが発生したので、値に絶対値を利用する
        // 参考: https://ios-docs.dev/invalid-frame-dimension/
        return abs(originCardWidth - offset)
    }

    // スワイプできるカード要素のオフセット値を算出する
    // 👉 SwipableCardView ~ .offsetの箇所でこの計算値を利用しています
    private func getCardOffset(proxy: GeometryProxy, id: Int) -> CGFloat {
        return CGFloat(contentViewStateProvider.foodMenus.count - 1 - id) * 6.0
    }
}

//#Preview {
//    ContentView()
//}
