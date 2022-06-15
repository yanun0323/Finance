//
//  ContentView.swift
//  Finance
//
//  Created by Yanun on 2022/6/15.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var content = ContentViewModel()
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea(.all)
            HomeView()
                .environmentObject(content)
        }
        .statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
