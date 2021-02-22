//
//  SceneDelegate.swift
//  FunctionalValidator
//
//  Created by Filo on 22/02/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: windowScene)
		let viewController = ViewController()
		let navigation = UINavigationController(rootViewController: viewController)
		window.rootViewController = navigation
		self.window = window
		window.makeKeyAndVisible()
	}
}
