import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainViewController = LoginViewController()
        window?.rootViewController = UINavigationController(rootViewController: mainViewController)
        self.window?.makeKeyAndVisible()

        return true
    }


}

