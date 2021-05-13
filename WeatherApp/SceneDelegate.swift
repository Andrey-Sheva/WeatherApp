//
//  SceneDelegate.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 28.04.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let container = DependencyContainer()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        AppAppearance.setupAppearance()
        let viewController = container.makeMainViewController()
        viewController.container = container
        let rootViewController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}

