//
//  SceneDelegate.swift
//  CameraFiltersHomework
//
//  Created by Анна Ереськина on 10.06.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        let filterService = FiltersService()
        let startVC = MainVC(filterService: filterService)
        
        window.rootViewController = UINavigationController(rootViewController: startVC)
        self.window = window
        
        window.makeKeyAndVisible()
    }
}

