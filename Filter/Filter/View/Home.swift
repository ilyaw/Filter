//
//  Home.swift
//  Filter
//
//  Created by Ilya on 05.10.2021.
//

import SwiftUI

struct Home: View {
    
    @StateObject var homeData = HomeViewModel()
    
    var body: some View {
        VStack {
            if !homeData.allImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(homeData.allImages) { (filtered) in
                            Image(uiImage: filtered.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                        }
                    }.padding()
                   
                }
            } else if homeData.imageData.count == 0 {
                Text("Pick An Image To Process :)")
            } else {
                ProgressView()
            }
        }
        .onChange(of: homeData.imageData, perform: { (_) in
            // when ever image is changed firing loadimage
            
            // clear existing data
            homeData.allImages.removeAll()
            homeData.loadFilter()
        })
        .toolbar {
            // Image Button ...
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    homeData.imagePicker.toggle()
                } label: {
                    Image(systemName: "photo")
                        .font(.title2)
                }
            }
        }
        .sheet(isPresented: $homeData.imagePicker) {
            ImagePicker(picker: $homeData.imagePicker, imageData: $homeData.imageData)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
