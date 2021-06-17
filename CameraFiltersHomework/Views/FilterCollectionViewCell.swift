//
//  CustomViewCell.swift
//  CameraFiltersHomework
//
//  Created by Анна Ереськина on 10.06.2021.
//

import UIKit

/// Ячейка отображающая картинку с фильтром
final class FilterCollectionViewCell: UICollectionViewCell {
    
    /// Картинка
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        return image
    }()
    
    /// Название фильтра
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 10)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .purple
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        makeConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Конфигурирование данных ячейки
    /// - Parameter model: модель данных
    func configure(with model: FilterModel) {
        imageView.image = model.image
        nameLabel.text = model.filterName
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            nameLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            nameLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
        ])
    }
}
