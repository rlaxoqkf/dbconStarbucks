import UIKit

// STEP 1과 STEP 2의 '틀'이 되는 TabBarController
class Step1ViewController: UITabBarController {

    // STEP 2에서 Home 탭의 내용을 교체할 수 있도록 외부에서 접근 가능하게 설정
    var homeViewController: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemGray6
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    // 네비게이션 바를 숨기는 코드 추가
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupTabs() {
        // 첫 번째 탭(Home)은 외부에서 설정된 ViewController를 사용
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        // 나머지 탭들 생성
        let vc2 = createTab(title: "Pay", icon: "creditcard.fill", tag: 1)
        let vc3 = createTab(title: "Order", icon: "cup.and.saucer.fill", tag: 2)
        let vc4 = createTab(title: "Shop", icon: "bag.fill", tag: 3)
        let vc5 = createTab(title: "Other", icon: "ellipsis", tag: 4)

        // 탭 바에 ViewController들을 설정
        self.viewControllers = [homeViewController, vc2, vc3, vc4, vc5]
    }
    
    // 탭을 만드는 헬퍼 함수
    private func createTab(title: String, icon: String, tag: Int) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemGray6
        vc.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: icon), tag: tag)
        return vc
    }
}
