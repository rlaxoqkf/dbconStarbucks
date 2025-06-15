// Step1ViewController.swift

import UIKit

class Step1ViewController: UITabBarController, UIGestureRecognizerDelegate { // Delegate 채택

    var homeViewController: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemGray6
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    // 네비게이션 바 숨김 및 제스처 활성화
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func setupTabs() {
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let vc2 = createTab(title: "Pay", icon: "creditcard.fill", tag: 1)
        let vc3 = createTab(title: "Order", icon: "cup.and.saucer.fill", tag: 2)
        let vc4 = createTab(title: "Shop", icon: "bag.fill", tag: 3)
        let vc5 = createTab(title: "Other", icon: "ellipsis", tag: 4)

        self.viewControllers = [homeViewController, vc2, vc3, vc4, vc5]
    }
    
    private func createTab(title: String, icon: String, tag: Int) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemGray6
        vc.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: icon), tag: tag)
        return vc
    }
}
