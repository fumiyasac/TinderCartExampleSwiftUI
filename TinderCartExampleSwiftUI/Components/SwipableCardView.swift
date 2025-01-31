//
//  SwipableCardView.swift
//  TinderCartExampleSwiftUI
//
//  Created by 酒井文也 on 2025/01/31.
//

import SwiftUI

struct SwipableCardView: View {

    // MARK: - Property

    //
    @State private var swipeStatus: SwipeStatus = .none

    //
    @State private var swipeOffset: CGSize = .zero

    //
    private let foodMenuEntity: FoodMenuEntity

    //
    private let removeAction: (_ foodMenuEntity: FoodMenuEntity) -> Void

    // 画面幅を基準としたスワイプ移動量の割合
    // 👉 この割合がCardを画面上から削除する基準となる
    private let thresholdActionPercentage: CGFloat = 0.5

    // 👉 この割合がCardを画面上から削除する基準となる
    private let thresholdMessagePercentage: CGFloat = 0.12
    
    // MARK: - Enum

    // Swipe時の状態を表現したEnum
    private enum SwipeStatus: Int {
        case addToCart, notSelect, none
    }

    // MARK: - Initializer

    init(
        foodMenuEntity: FoodMenuEntity,
        removeAction: @escaping (_ foodMenuEntity: FoodMenuEntity) -> Void
    ) {
        self.foodMenuEntity = foodMenuEntity
        self.removeAction = removeAction
    }

    // MARK: - Body

    var body: some View {

        // 👉 画面幅を基準としてスワイプ変化量算出のために、GeometryReaderを画面全体に適用する
        GeometryReader { proxy in
            
            //
            VStack(alignment: .leading) {
                
                //
                ZStack(alignment: self.swipeStatus == .addToCart ? .topLeading : .topTrailing) {
                    
                    //
                    Image(foodMenuEntity.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()

                    //
                    if swipeStatus == .addToCart {
                        
                        Text("🛒今日はコレ！")
                            .font(.headline)
                            .padding()
                            .foregroundColor(Color.green)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0.0)
                                    .stroke(Color.green, lineWidth: 3.0)
                            )
                            .background(.white)
                            .padding(24.0)
                        
                    //
                    } else if swipeStatus == .notSelect {
                        
                        Text("🙅違うかなぁ…")
                            .font(.headline)
                            .padding()
                            .foregroundColor(Color.red)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0.0)
                                    .stroke(Color.red, lineWidth: 3.0)
                            )
                            .background(.white)
                            .padding(24.0)

                    //
                    } else {
                        EmptyView()
                    }
                    
                }
                //
                HStack {
                    VStack(alignment: .leading, spacing: 8.0) {
                        Text(foodMenuEntity.name)
                            .font(.title)
                            .bold()
                        Text(foodMenuEntity.caregory)
                            .font(.subheadline)
                            .bold()
                    }
                    Spacer()
                    Image(systemName: "info.circle")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(8.0)
            .shadow(radius: 4.0)
            //
            .animation(.spring, value: swipeOffset)
            //
            .offset(x: swipeOffset.width, y: 4.0)
            //
            .rotationEffect(.degrees(Double(swipeOffset.width / proxy.size.width) * 25.0), anchor: .bottom)
            //
            .gesture(
                DragGesture()
                    .onChanged { value in

                        //
                        swipeOffset = value.translation

                        //
                        if getGesturePercentageBasedOnScreenWidth(proxy: proxy, dragGestureValue: value) >= thresholdMessagePercentage {
                            swipeStatus = .addToCart
                        } else if getGesturePercentageBasedOnScreenWidth(proxy: proxy, dragGestureValue: value) <= -thresholdMessagePercentage {
                            swipeStatus = .notSelect
                        } else {
                            swipeStatus = .none
                        }
                        
                    }
                    .onEnded { value in

                        // determine snap distance > 0.5 aka half the width of the screen
                        if abs(getGesturePercentageBasedOnScreenWidth(proxy: proxy, dragGestureValue: value)) > thresholdActionPercentage {

                            //
                            removeAction(foodMenuEntity)

                        } else {

                            //
                            swipeOffset = .zero
                            swipeStatus = .none
                        }
                    }
            )
            
        }
    }

    // MARK: - Private Function

    // 画面幅を基準とした移動量の割合を算出する
    private func getGesturePercentageBasedOnScreenWidth(proxy: GeometryProxy, dragGestureValue: DragGesture.Value) -> CGFloat {
        dragGestureValue.translation.width / proxy.size.width
    }
}

#Preview {
    SwipableCardView(
        foodMenuEntity: FoodMenuEntity(
            id: 1,
            name: "熱々グラタン",
            caregory: "洋風・オーブン料理",
            imageName: "food_example1"
        ),
        removeAction: { _ in print("removed!") }
    )
    .frame(height: 350.0)
    .padding()
}
