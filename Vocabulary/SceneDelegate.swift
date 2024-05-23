//
//  SceneDelegate.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        // LaunchScreen
        let launchScreenViewController = UIViewController()
        let launchImageView = UIImageView(frame: window!.bounds)
        launchImageView.image = UIImage(named: "launchScreen")
        launchImageView.contentMode = .scaleAspectFill
        launchScreenViewController.view.addSubview(launchImageView)
        
        let tabBarVC = UITabBarController()
        
        let addBookVC = BookCaseViewController()
        addBookVC.tabBarItem = UITabBarItem(title: "단어장", image: UIImage(systemName: "book.pages"), selectedImage: UIImage(systemName: "book.pages.fill"))
        
        let gameMainPageVC = GameMainPageViewController()
        gameMainPageVC.tabBarItem = UITabBarItem(title: "단어 퀴즈", image: UIImage(systemName: "gamecontroller"), selectedImage: UIImage(systemName: "gamecontroller.fill"))
        
        let calenderVC = CalenderViewController()
        calenderVC.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(named: "tcalendar"), selectedImage: UIImage(named: "tcalendar.fill"))
        
        let myPageVC = MyPageViewController()
        myPageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        tabBarVC.viewControllers = [addBookVC, gameMainPageVC, calenderVC, myPageVC]
        
        let tabBar = tabBarVC.tabBar
        tabBar.barTintColor = ThemeColor.mainColor
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .white
        tabBar.itemPositioning = .centered
        tabBar.layer.masksToBounds = false
        tabBar.layer.cornerRadius = 46
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = ThemeColor.mainColor
        backgroundView.layer.cornerRadius = 46
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.insertSubview(backgroundView, at: 0)
        
        backgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(-10)
            $0.bottom.equalTo(tabBar.snp.bottom)
            $0.top.equalTo(tabBar.snp.top).inset(-10)
        }
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        self.window?.rootViewController = launchScreenViewController
        window?.makeKeyAndVisible()
        
        // 1초 후 Main으로 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.window?.rootViewController = tabBarVC
        }
        
        // delegate 설정
        
        gameMainPageVC.delegate = myPageVC
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

