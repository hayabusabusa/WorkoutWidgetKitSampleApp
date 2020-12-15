//
//  HomeScreen.swift
//  Workout
//
//  Created by 山田隼也 on 2020/12/14.
//

import SwiftUI

struct HomeScreen: View {
    @ObservedObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack() {
            ScrollView {
                Text("アプリの使い方")
                    .font(.largeTitle)
                    .bold()
                Spacer().frame(height: 40.0)
                VStack(alignment: .leading, spacing: 20.0) {
                    InfoView(image: Image(systemName: "flame.fill"), color: .red, headline: "ワークアウトを表示", description: "ホーム画面に追加したウィジェットにワークアウトを表示します")
                    
                    InfoView(image: Image(systemName: "heart.text.square.fill"), color: .red, headline: "ヘルスケアとの連携", description: "ワークアウトデータの取得のためにヘルスケアにアクセスする許可が必要です")
                    
                    if (viewModel.isLoading) {
                        LoadingView(description: "アクセス状態を確認中です")
                    } else {
                        if (viewModel.isAuthorized) {
                            InfoView(image: Image(systemName: "checkmark.circle.fill"), color: .blue, headline: "アクセス許可済みです", description: "許可されていることを確認しました")
                        } else {
                            InfoView(image: Image(systemName: "checkmark.circle.fill"), color: .red, headline: "アクセスが許可されていません", description: "設定アプリからヘルスケアへのアクセスを許可してください")
                        }
                    }
                }
            }
            Spacer()
            Button(action: {
                
            }) {
                Text(viewModel.isAuthorized ? "認証済みです" : "認証する")
                    .bold()
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding([.top, .bottom], 12)
            .background(viewModel.isAuthorized ? Color.red.opacity(0.3) : Color.red)
            .cornerRadius(8.0)
        }
        .padding(EdgeInsets(top: 40, leading: 24, bottom: 24, trailing: 24))
        .onAppear(perform: {
            viewModel.onAppear()
        })
    }
}

struct InfoView: View {
    let image: Image
    let color: Color
    let headline: String
    let description: String
    
    var body: some View {
        HStack(spacing: 14.0) {
            image
                .font(.largeTitle)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4.0) {
                Text(headline)
                    .foregroundColor(.black)
                    .font(.headline)
                    .bold()
                Text(description)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct LoadingView: View {
    let description: String
    @State var isAnimating: Bool = true
    
    var body: some View {
        HStack(spacing: 8.0) {
            ActivityIndicator(isAnimating: $isAnimating, style: .large)
            
            Text(description)
                .font(.callout)
                .foregroundColor(.gray)
        }
    }
}

struct HomeScreen_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            HomeScreen()
                
        }
    }
}

struct InfoView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            InfoView(image: Image(systemName: "figure.walk"), color: .blue, headline: "歩数を表示", description: "その日の歩数を表示します")
                .previewLayout(.sizeThatFits)
        }
        
    }
}

struct LoadingView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingView(description: "説明文", isAnimating: true)
                .previewLayout(.sizeThatFits)
        }
    }
}
