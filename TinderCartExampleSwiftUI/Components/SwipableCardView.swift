//
//  SwipableCardView.swift
//  TinderCartExampleSwiftUI
//
//  Created by 酒井文也 on 2025/01/31.
//

import SwiftUI

struct SwipableCardView: View {

    // MARK: - Property

    // スワイプ動作時のStatusを保持する
    @State private var swipeStatus: SwipeStatus = .none

    // Drag処理時（ここではスワイプ動作時と同義）の変化量を保持する
    @State private var swipeOffset: CGSize = .zero

    private let foodMenuEntity: FoodMenuEntity

    // 配置元の画面から削除する際に実行したいActionのClosure
    private let removeAction: (_ foodMenuEntity: FoodMenuEntity) -> Void

    // 画面幅を基準としたスワイプ移動量の割合
    // 👉 この割合がCardを画面上から削除する基準となる
    private let thresholdActionPercentage: CGFloat = 0.45

    // 👉 この割合がSwipe動作中にメッセージを表示する基準となる
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
            
            // 要素全体を囲むVStack
            VStack(alignment: .leading) {
                
                // ① サムネイル画像
                // 👉 サムネイル画像の上にメッセージを表示したいので、ZStackで囲んでいる
                ZStack(alignment: self.swipeStatus == .addToCart ? .topLeading : .topTrailing) {
                    
                    // メインで表示するサムネイル画像
                    Image(foodMenuEntity.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()

                    // 👉 右Swipe時に左上にメッセージを表示する
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
                        
                    // 👉 左Swipe時に左上にメッセージを表示する
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

                    // 👉 スワイプ時以外は何も表示しない
                    } else {
                        EmptyView()
                    }
                }
                // ② サムネイル画像に関連する情報を表示する
                HStack {
                    VStack(alignment: .leading, spacing: 8.0) {
                        Text(foodMenuEntity.name)
                            .font(.callout)
                            .bold()
                            .padding(.top, 12.0)
                        VStack {
                            Text(foodMenuEntity.caregory)
                                .font(.caption)
                                .bold()
                                .foregroundStyle(.white)
                                .padding(4.0)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 0.0)
                                    .stroke(Color.orange, lineWidth: 1.0)
                        )
                        .background(.orange)
                        .padding(.top, 4.0)
                            
                    }
                    Spacer()
                    HStack {
                        Button(action: {}, label: {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        })
                        Button(action: {}, label: {
                            Image(systemName: "cart.fill")
                                .foregroundColor(.brown)
                        })
                        .padding(.horizontal, 10.0)
                        Button(action: {}, label: {
                            Image(systemName: "frying.pan.fill")
                                .foregroundColor(.gray)
                        })
                    }
                    .padding(.top, 4.0)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(8.0)
            .shadow(radius: 4.0)
            // 操作時にバネ運動の様なAnimationを付与する
            // 👉 しきい値を超過せずに元に戻る場合
            .animation(.spring, value: swipeOffset)
            // スワイプ処理時にX軸方法のOffset値を変更する
            .offset(x: swipeOffset.width, y: 4.0)
            // スワイプ処理時にこのView要素に対して回転処理を利用して傾きをつける
            .rotationEffect(.degrees(Double(swipeOffset.width / proxy.size.width) * 24.0), anchor: .bottom)
            // DragGestureを利用してスワイプ動作を組み立てる
            .gesture(
                DragGesture()
                    .onChanged { value in

                        // スワイプ変化量を変数に保持する
                        swipeOffset = value.translation

                        // 移動量の割合に応じてメッセージを表示する
                        if getGesturePercentageBasedOnScreenWidth(proxy: proxy, dragGestureValue: value) >= thresholdMessagePercentage {
                            swipeStatus = .addToCart
                        } else if getGesturePercentageBasedOnScreenWidth(proxy: proxy, dragGestureValue: value) <= -thresholdMessagePercentage {
                            swipeStatus = .notSelect
                        } else {
                            swipeStatus = .none
                        }
                        
                    }
                    .onEnded { value in

                        // 画面幅の半分以上まで動いた際は、この要素を削除対象とする
                        if abs(getGesturePercentageBasedOnScreenWidth(proxy: proxy, dragGestureValue: value)) > thresholdActionPercentage {

                            // 配置元でこのView要素を削除する処理を実行する
                            removeAction(foodMenuEntity)

                        } else {

                            // 現在状態とスワイプ変化量をリセットする
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
            name: "熱々エビグラタン",
            caregory: "洋風・オーブン料理",
            imageName: "food_example1"
        ),
        removeAction: { _ in print("removed!") }
    )
    .frame(height: 350.0)
    .padding()
}
