//
//  ContentView.swift
//  Filter
//
//  Created by Ilya on 05.10.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Home()
                .navigationTitle("Filter")
                .preferredColorScheme(.dark)
                
        }.navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
