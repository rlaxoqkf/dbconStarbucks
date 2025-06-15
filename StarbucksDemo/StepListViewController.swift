// StepListViewController.swift

import UIKit

class StepListViewController: UITableViewController {
    
    private let steps: [(title: String, description: String)] = [
        ("STEP 1", "스타벅스 하단바 메뉴 구성"),
        ("STEP 2", "스타벅스 상단 배너 및 스티키 메뉴"),
        ("STEP 3", "스타벅스 퀵 주문 메뉴 (미구현)"),
        ("STEP 4", "스타벅스 인디케이터 (미구현)"),
        ("STEP 5", "스타벅스 회사 배너 (미구현)"),
        ("STEP 6", "스타벅스 카드/간편결제 (미구현)")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Starbucks Clone (Steps)"
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell", for: indexPath)
        
        let step = steps[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = step.title
        content.secondaryText = step.description
        
        let isEnabled = indexPath.row <= 1
        if !isEnabled {
            content.textProperties.color = .lightGray
            content.secondaryTextProperties.color = .lightGray
        }

        cell.contentConfiguration = content
        cell.accessoryType = isEnabled ? .disclosureIndicator : .none
        cell.isUserInteractionEnabled = isEnabled
        
        return cell
    }
    
    // 화면 전환 직전에 호출되는 메서드 (핵심 수정)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 이동할 목적지가 'Step1ViewController'(탭 바의 틀)인지 확인
        guard let tabBarController = segue.destination as? Step1ViewController else { return }

        // STEP 2 화면으로 이동할 때만 특별한 작업을 수행
        if segue.identifier == "showStep2" {
            // 탭 바의 첫 번째 탭(Home)의 내용물을 StarbucksMainViewController로 교체
            tabBarController.homeViewController = StarbucksMainViewController()
        }
        // STEP 1일 때는 기본값(빈 화면)을 사용하므로 별도 처리 필요 없음
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "showStep1", sender: nil)
        case 1:
            performSegue(withIdentifier: "showStep2", sender: nil)
        default:
            break
        }
    }
}
