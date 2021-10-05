//
//  HomeViewModel.swift
//  Filter
//
//  Created by Ilya on 05.10.2021.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var imagePicker = false
    @Published var imageData = Data(count: 0)
    
}
