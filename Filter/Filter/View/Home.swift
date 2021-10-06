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
            if !homeData.allImages.isEmpty && homeData.mainView != nil {
                
                Spacer(minLength: 0)
                
                Image(uiImage: homeData.mainView.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width)
                
                Slider(value: $homeData.value)
                    .padding()
                    .opacity(homeData.mainView.isEditable ? 1 : 0)
                    .disabled(homeData.mainView.isEditable ? false : true)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(homeData.allImages) { (filtered) in
                            Image(uiImage: filtered.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .onTapGesture {
                                    homeData.value = 1.0
                                    homeData.mainView = filtered
                                }
                            
                        }
                    }.padding()
                    
                }
            } else if homeData.imageData.count == 0 {
                Text("Pick An Image To Process :)")
            } else {
                ProgressView()
            }
        }
        .onChange(of: homeData.value, perform: { (_) in
            homeData.updateEffect()
        })
        .onChange(of: homeData.imageData, perform: { (_) in
            // when ever image is changed firing loadimage
            
            // clear existing data
            homeData.allImages.removeAll()
            homeData.mainView = nil
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
            
            // Saving image
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    UIImageWriteToSavedPhotosAlbum(homeData.mainView.image, nil, nil, nil)
                } label: {
                    Image(systemName: "square.and.arrow.up.fill")
                        .font(.title2)
                }
                .disabled(homeData.mainView == nil)
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
