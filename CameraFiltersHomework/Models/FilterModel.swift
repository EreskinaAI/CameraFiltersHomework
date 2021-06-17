//
//  FilterModel.swift
//  CameraFiltersHomework
//
//  Created by Анна Ереськина on 17.06.2021.
//

import UIKit

/// Модель фильтра
class FilterModel {
    /// Картинка
    var image: UIImage?
    /// Название фильтра
    let filterName: String
    
    /// Инициализатор
    /// - Parameter filterName: название фильтра
    init(filterName: String ) {
        self.filterName = filterName
    }
}
