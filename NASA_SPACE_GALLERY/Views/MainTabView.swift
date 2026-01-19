//
//  MainTabView.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 19/01/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab ("Home",systemImage: "house.fill") {
                HomeView()
            }
            Tab("Favorite", systemImage: "heart.fill") {
                    FavoriteView()
            }
        }
        .tint(Color("BrandColor"))
    }
}

#Preview {
    MainTabView()
}
