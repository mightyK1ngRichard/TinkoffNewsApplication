//
//  SceneDelegate.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var navigationView = UINavigationController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigation = UINavigationController(rootViewController:  NewsComposer.make())
        self.navigationView = navigation
        window.rootViewController = navigationView
        self.window = window
        window.makeKeyAndVisible()
    }

}

