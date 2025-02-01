//
//  ContentView.swift
//  TinderCartExampleSwiftUI
//
//  Created by 酒井文也 on 2025/01/30.
//

import SwiftUI

// 参考:
// https://github.com/bbaars/SwiftUI-Tinder-SwipeableCards

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
                
                //
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

                //
                if contentViewStateProvider.foodMenus.isEmpty {
                    
                    //
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
                
                //
                } else {
                    
                    //
                    GeometryReader { proxy in
                        ZStack {
                            ForEach(contentViewStateProvider.foodMenus, id: \.self) { foodMenuEntity in
                                Group {
                                    //
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
 
                // 👉
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

    //
    private func getCardWidth(proxy: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = getCardOffset(proxy: proxy, id: id)
        let originCardWidth: CGFloat = proxy.size.width - 36.0
        // 👉
        // https://ios-docs.dev/invalid-frame-dimension/
        return abs(originCardWidth - offset)
    }

    private func getCardOffset(proxy: GeometryProxy, id: Int) -> CGFloat {
        return CGFloat(contentViewStateProvider.foodMenus.count - 1 - id) * 6.0
    }
}

//#Preview {
//    ContentView()
//}
