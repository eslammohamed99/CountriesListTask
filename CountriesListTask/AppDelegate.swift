//
//  AppDelegate.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 25/03/2025.
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var rootCoordinator: BaseCoordinatorProtocol?
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = AppWindow.shared
        window?.backgroundColor = .white
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        
        openCountriesCoordinator()
        
        return true
    }
    func openCountriesCoordinator() {
        guard let window = self.window else {
            return
        }
        struct UseCase: CountriesListCoordinatorUseCaseProtocol {
            var window: UIWindow
        }
        let root = CountriesListCoordinator(useCase: UseCase(window: window))
        rootCoordinator = root
        root.start()
    }

}

class AppWindow {
    static let shared = UIWindow(frame: UIScreen.main.bounds)
}

let appDelegate = UIApplication.shared.delegate as? AppDelegate
