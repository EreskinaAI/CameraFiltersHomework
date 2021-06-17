//
//  FiltersService.swift
//  CameraFiltersHomework
//
//  Created by Анна Ереськина on 14.06.2021.
//
import UIKit

/// Протокол сервиса по работе с фильтрами
protocol FiltersServiceProtocol {
    
    /// Получить список фильтров по ключу
    /// - Parameter inputKey: ключ у фильтра
    func getFilters(with inputKey: String) -> [String]
    
    /// Применить фильтер к картинке
    /// - Parameters:
    ///   - filter: название фильтра
    ///   - originImage: оригинал картинки
    ///   - intensity: интенсивность фильтра
    func apply(filter: String, to originImage: UIImage?, intensity: Float) -> UIImage?
}

/// Сервис для работы с фильтрами для картинки
final class FiltersService: FiltersServiceProtocol {
    
    func getFilters(with inputKey: String) -> [String] {
        return CIFilter
            .filterNames(inCategory: kCICategoryBuiltIn)
            .filter { CIFilter(name: $0)?.inputKeys.contains(kCIInputIntensityKey) ?? false }
    }
    
    func apply(filter: String, to originImage: UIImage?, intensity: Float) -> UIImage? {
        let context = CIContext()
        
        if let filter = CIFilter(name: filter), let image = originImage {
            let ciImage = CIImage(image: image)
            
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            filter.setValue(intensity, forKey: kCIInputIntensityKey)
            
            if let outputImage = filter.outputImage {
                if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                    let filteredImage = UIImage(cgImage: cgImage)
                    return filteredImage
                }
            }
        }
        
        return originImage
    }
}
