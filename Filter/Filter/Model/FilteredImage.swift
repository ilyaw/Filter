//
//  FilteredImage.swift
//  Filter
//
//  Created by Ilya on 05.10.2021.
//

import SwiftUI
import CoreImage

struct FilteredImage: Identifiable {
    var id = UUID().uuidString
    var image: UIImage
    var filter: CIFilter
    var isEditable: Bool
}
