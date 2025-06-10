import UIKit

class ViewController: UIViewController {

    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bannerImage") ?? .init(systemName: "photo")
        imageView.backgroundColor = .systemTeal
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let bannerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "고객님의 오늘,\n눈부신 푸르름이 가득하시길"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // --- 원본 메뉴 ---
    private let menuScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let menuStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // --- 스티키 헤더 (최종 재설계) ---
    
    // 1. 노치 영역을 가릴 불투명한 흰색 뷰 (가장 뒤)
    private let notchOpaqueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 2. 그라데이션 배경을 담을 뷰 (중간)
    private let gradientBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 3. 실제 메뉴 아이템 스크롤뷰 (가장 앞)
    private let stickyMenuScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.alpha = 0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stickyMenuStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var eventCards: [UIImageView] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEventCards()
        setupUI()
        setupLayout()
        addMenuItems()
        setupDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addGradientToStickyBackground()
    }
    
    // MARK: - UI Setup
    
    private func setupEventCards() {
        for i in 1...10 {
            let imageName = "eventCard\((i - 1) % 3 + 1)"
            eventCards.append(createEventCardImageView(imageName: imageName))
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(scrollView)
        // 뷰 계층 설정: 노치 배경 -> 그라데이션 배경 -> 메뉴 순으로 추가
        self.view.addSubview(notchOpaqueBackgroundView)
        self.view.addSubview(gradientBackgroundView)
        self.view.addSubview(stickyMenuScrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(bannerImageView)
        contentView.addSubview(menuScrollView)
        menuScrollView.addSubview(menuStackView)
        
        eventCards.forEach { contentView.addSubview($0) }
        
        bannerImageView.addSubview(bannerTitleLabel)
        
        stickyMenuScrollView.addSubview(stickyMenuStackView)
    }
    
    private func setupLayout() {
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(contentsOf: [
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerImageView.heightAnchor.constraint(equalToConstant: 250),
            
            bannerTitleLabel.leadingAnchor.constraint(equalTo: bannerImageView.leadingAnchor, constant: 20),
            bannerTitleLabel.bottomAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: -60),
            
            menuScrollView.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: -35),
            menuScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            menuScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            menuScrollView.heightAnchor.constraint(equalToConstant: 70),

            menuStackView.leadingAnchor.constraint(equalTo: menuScrollView.leadingAnchor, constant: 16),
            menuStackView.trailingAnchor.constraint(equalTo: menuScrollView.trailingAnchor, constant: -16),
            menuStackView.centerYAnchor.constraint(equalTo: menuScrollView.centerYAnchor),
            menuStackView.heightAnchor.constraint(equalToConstant: 50),
            
            // --- 스티키 헤더 레이아웃 ---
            // 1. 노치 배경 뷰
            notchOpaqueBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            notchOpaqueBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            notchOpaqueBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            notchOpaqueBackgroundView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),

            // 2. 그라데이션 배경 뷰: Safe Area 상단에 위치, 높이 60
            gradientBackgroundView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            gradientBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            gradientBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            gradientBackgroundView.heightAnchor.constraint(equalToConstant: 60),

            // 3. 스티키 메뉴 스크롤뷰: 그라데이션 뷰와 동일한 위치/크기
            stickyMenuScrollView.topAnchor.constraint(equalTo: gradientBackgroundView.topAnchor),
            stickyMenuScrollView.leadingAnchor.constraint(equalTo: gradientBackgroundView.leadingAnchor),
            stickyMenuScrollView.trailingAnchor.constraint(equalTo: gradientBackgroundView.trailingAnchor),
            stickyMenuScrollView.heightAnchor.constraint(equalTo: gradientBackgroundView.heightAnchor),
            
            // 4. 스티키 메뉴 스택뷰
            stickyMenuStackView.leadingAnchor.constraint(equalTo: stickyMenuScrollView.leadingAnchor, constant: 16),
            stickyMenuStackView.trailingAnchor.constraint(equalTo: stickyMenuScrollView.trailingAnchor, constant: -16),
            stickyMenuStackView.centerYAnchor.constraint(equalTo: stickyMenuScrollView.centerYAnchor),
            stickyMenuStackView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        var previousAnchor = menuScrollView.bottomAnchor
        for card in eventCards {
            constraints.append(contentsOf: [
                card.topAnchor.constraint(equalTo: previousAnchor, constant: 20),
                card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
            previousAnchor = card.bottomAnchor
        }
        
        if let lastCard = eventCards.last {
            constraints.append(lastCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupDelegates() {
        scrollView.delegate = self
        menuScrollView.delegate = self
        stickyMenuScrollView.delegate = self
    }

    // MARK: - Private Methods
    private func addMenuItems() {
        let menuItems: [(icon: String, title: String)] = [
            ("star.fill", "Welcome 4/5"),
            ("giftcard.fill", "Coupon"),
            ("creditcard.fill", "Pay"),
            ("calendar", "Buddy Pass")
        ]
        
        for item in menuItems {
            menuStackView.addArrangedSubview(createMenuItem(iconName: item.icon, title: item.title))
            stickyMenuStackView.addArrangedSubview(createMenuItem(iconName: item.icon, title: item.title))
        }
    }
    
    private func createMenuItem(iconName: String, title: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.08
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        
        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.tintColor = .darkGray
        iconImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = .black
        
        [containerView, iconImageView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        containerView.layer.cornerRadius = 25
        
        return containerView
    }
    
    private func createEventCardImageView(imageName: String) -> UIImageView {
        let imageView = UIImageView()
        if let image = UIImage(named: imageName) {
            imageView.image = image
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: image.size.height / image.size.width).isActive = true
        } else {
            imageView.backgroundColor = .systemGray4
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    // 스티키 메뉴바 배경에 그라데이션을 추가하는 메서드
    private func addGradientToStickyBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientBackgroundView.bounds
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        
        // 이전에 추가된 레이어가 있다면 제거
        gradientBackgroundView.layer.sublayers?.removeAll()
        gradientBackgroundView.layer.addSublayer(gradientLayer)
    }
}

// MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let originalMenuYPosition = bannerImageView.frame.height - 35
        let stickyPoint = originalMenuYPosition - self.view.safeAreaInsets.top

        if scrollView == self.scrollView {
            // 뷰 계층을 다시 한 번 정리하여 스크롤 시에도 최상단을 유지
            self.view.bringSubviewToFront(notchOpaqueBackgroundView)
            self.view.bringSubviewToFront(gradientBackgroundView)
            self.view.bringSubviewToFront(stickyMenuScrollView)
            
            if scrollView.contentOffset.y > stickyPoint {
                let alpha = min(1, (scrollView.contentOffset.y - stickyPoint) / 20)
                // 3개의 뷰를 함께 제어
                notchOpaqueBackgroundView.alpha = alpha
                gradientBackgroundView.alpha = alpha
                stickyMenuScrollView.alpha = alpha
                // 겹침 현상 방지를 위해 원본 메뉴는 숨김
                menuScrollView.alpha = 1 - alpha
            } else {
                notchOpaqueBackgroundView.alpha = 0
                gradientBackgroundView.alpha = 0
                stickyMenuScrollView.alpha = 0
                // 원본 메뉴 다시 표시
                menuScrollView.alpha = 1
            }
        }
        
        // 두 메뉴 스크롤뷰의 위치를 동기화
        if scrollView == menuScrollView {
            stickyMenuScrollView.contentOffset = scrollView.contentOffset
        } else if scrollView == stickyMenuScrollView {
            menuScrollView.contentOffset = scrollView.contentOffset
        }
    }
}
