//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()

        coordinator = MainCoordinator(navigationController: navigationController)
        coordinator?.start()

        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
