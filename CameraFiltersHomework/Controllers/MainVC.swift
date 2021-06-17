//
//  ViewController.swift
//  CameraFiltersHomework
//
//  Created by Анна Ереськина on 10.06.2021.
//

import UIKit

/// Протокол главного экрана
protocol MainVCDelegate: AnyObject {
    /// Интенсивность фильтра
    var filterIntensity: Float { get set}
}

/// Главный контроллер отображает картинку и фильтры
final class MainVC: UIViewController, MainVCDelegate {
    
    var filterIntensity: Float = 0.5
    
    /// Текущий выбранный фильтр
    private var choosedFilter: String = ""
    
    /// Оригинал картинки
    private var originImage = UIImage(named: "noPhoto")
    
    /// Сервис работы с фильтрами
    private var filterService: FiltersServiceProtocol
    
    /// Массив моделей фильтров
    private lazy var filterList: [FilterModel] = filterService
        .getFilters(with: kCIInputIntensityKey)
        .compactMap { FilterModel(filterName: $0) }
    
    /// Большая картинка
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePressed)))
        
        return imageView
    }()
    
    /// Коллекция с фильтрами
    private lazy var filterCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "CustomViewCell")
        collection.dataSource = self
        collection.delegate = self
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .gray
        
        return collection
    }()
    
    /// Контроллер выбора картинки из галереи
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        return imagePicker
    }()
    
    /// Инициализатор
    /// - Parameter filterService: сервис по работе с фильтрами
    init(filterService: FiltersServiceProtocol) {
        self.filterService = filterService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        makeConstraints()
        configurateNavBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateImage()
    }
}

extension MainVC {
    /// Настройки вьюх
    private func setUpView() {
        view.backgroundColor = .gray
        view.addSubview(imageView)
        view.addSubview(filterCollection)
    }
    
    /// Установка констреинтов
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalToConstant: 550),
            
            filterCollection.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            filterCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            filterCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            filterCollection.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    /// Конфигурация  navigarionBar
    private func configurateNavBar() {
        self.title = "Filter Names"
        let barButton = UIBarButtonItem(image: UIImage(named: "settingsIcon"), style: .plain, target: self, action: #selector(showSettings))
        self.navigationItem.setRightBarButton(barButton, animated: true)
        
    }
    
    /// Обновление картинок
    private func updateImage() {
        filterCollection.reloadData()
        
        imageView.image = filterService.apply(filter: choosedFilter,
                                              to: originImage,
                                              intensity: filterIntensity)
        
        filterList.forEach { model in
            model.image = filterService.apply(filter: model.filterName,
                                              to: originImage,
                                              intensity: filterIntensity)
        }
    }
    
    /// Обработка нажатия на большую картинку
    @objc private func imagePressed() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// Переход на экран настроек
    @objc private func showSettings() {
        let setUpVC = SetUpVC()
        setUpVC.delegate = self
        navigationController?.pushViewController(setUpVC, animated: true)
    }
}

//MARK:- UICollectionViewDataSource

extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomViewCell", for: indexPath) as? FilterCollectionViewCell ?? FilterCollectionViewCell()
        
        cell.configure(with: filterList[indexPath.item])
        
        //        cell.imageView.image = filterService.apply(filter: filterList[indexPath.item].filterName, to: filterList[indexPath.item].image, intensity: filterIntensity)
        
        return cell
    }
}

//MARK:- UICollectionViewDelegate

extension MainVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        choosedFilter = filterList[indexPath.item].filterName
        
        imageView.image = filterService.apply(filter: choosedFilter, to: originImage, intensity: filterIntensity)
    }
}

//MARK:- UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[.editedImage] as? UIImage
        imageView.image = editedImage
        originImage = editedImage
        
        filterList.forEach { model in
            model.image = editedImage
        }
        
        updateImage()
        
        dismiss(animated: true, completion: nil)
    }
}
