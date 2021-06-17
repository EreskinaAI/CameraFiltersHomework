//
//  SetUpVC.swift
//  CameraFiltersHomework
//
//  Created by Анна Ереськина on 10.06.2021.
//

import UIKit

/// Контроллер настройки интенсивности
final class SetUpVC: UIViewController {
    
    /// Делегат главного экрана
    weak var delegate: MainVCDelegate?
    
    /// Слайдер изменения интенсивности фильтра
    private let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 0
        slider.minimumValue = 0
        slider.maximumValue = 1
        return slider
    }()
    
    /// Заголовок слайдера
    private let intensityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Интенсивность"
        label.textColor = .red
        label.textAlignment = .center
        label.font = label.font.withSize(26)
        label.backgroundColor = .green
        label.numberOfLines = 0
        return label
    }()
    
    /// Кнопка сохранения интенсивности
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = .yellow
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
        
    }()
    
    //MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        makeConstraints()
        
        slider.value = delegate?.filterIntensity ?? 0
    }
}

extension SetUpVC {
    private func setUpView() {
        view.backgroundColor = .green
        view.addSubview(intensityLabel)
        view.addSubview(slider)
        view.addSubview(saveButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            intensityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            intensityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            intensityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            intensityLabel.heightAnchor.constraint(equalToConstant: 40),
            
            slider.topAnchor.constraint(equalTo: intensityLabel.bottomAnchor, constant: 100),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            saveButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 100),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func buttonTapped() {
        delegate?.filterIntensity = slider.value
        navigationController?.popViewController(animated: true)
    }
}
