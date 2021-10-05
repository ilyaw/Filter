//
//  HomeViewModel.swift
//  Filter
//
//  Created by Ilya on 05.10.2021.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class HomeViewModel: ObservableObject {
    @Published var imagePicker = false
    @Published var imageData = Data(count: 0)
    
    @Published var allImages: [FilteredImage] = []
    
    // loading filter option whenever images is selected
    
    //Use your own filters
    let filters: [CIFilter] = [
        CIFilter.sepiaTone(), CIFilter.comicEffect(), CIFilter.colorInvert(),
        CIFilter.photoEffectFade(), CIFilter.colorMonochrome(), CIFilter.photoEffectChrome(),
        CIFilter.gaussianBlur(), CIFilter.bloom()
    ]
    
    func loadFilter() {
        
        let context = CIContext()
        
        filters.forEach { (filter) in
            
            DispatchQueue.global(qos: .userInteractive).async {
                // loading image into filter
                let ciImage = CIImage(data: self.imageData)
                filter.setValue(ciImage!, forKey: kCIInputImageKey)
                
                // retrieving image
                
                guard let newImage = filter.outputImage else { return }
                
                // creating UIImage
                let cgimage = context.createCGImage(newImage, from: newImage.extent)
                let filteredData = FilteredImage(image: UIImage(cgImage: cgimage!), filter: filter)
                
                DispatchQueue.main.async {
                    self.allImages.append(filteredData)
                }
            }
        }
    }
}
