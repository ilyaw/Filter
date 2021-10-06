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
    
    // Main editing image
    @Published var mainView: FilteredImage!
    
    // Slider for intensity and radius etc..
    @Published var value:  CGFloat = 1.0
    
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
                
                let isEditable = filter.inputKeys.count > 1
                
                let filteredData = FilteredImage(image: UIImage(cgImage: cgimage!), filter: filter, isEditable: isEditable)
                
                DispatchQueue.main.async {
                    self.allImages.append(filteredData)
                    
                    // default is first filter
                    
                    if self.mainView == nil {
                        self.mainView = self.allImages.first
                    }
                }
            }
        }
    }
    
    func updateEffect() {
        
        let context = CIContext()
        
        filters.forEach { (filter) in
            
            DispatchQueue.global(qos: .userInteractive).async {
                // loading image into filter
                let ciImage = CIImage(data: self.imageData)
                
                let filter = self.mainView.filter
                
                filter.setValue(ciImage!, forKey: kCIInputImageKey)
                
                // retrieving image
    
                // there are lot if custom options are available
                // im only using radius and itensity
                
                if filter.inputKeys.contains("inputRadius") {
                    filter.setValue(self.value * 10, forKey: kCIInputRadiusKey)
                }
                
                if filter.inputKeys.contains("inputIntensity") {
                    filter.setValue(self.value, forKey: kCIInputIntensityKey)
                }
                
//                if filter.inputKeys.contains("inputImage") {
//                    filter.setValue(self.value, forKey: kCIInputImageKey)
//                }
                
                
                guard let newImage = filter.outputImage else { return }
                
                // creating UIImage
                let cgimage = context.createCGImage(newImage, from: newImage.extent)
             
                
                DispatchQueue.main.async {
                    
                    // update view
                    self.mainView.image = UIImage(cgImage: cgimage!)
                    
                }
            }
        }
    }
}
