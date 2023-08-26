//
//  OnboardingVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/26.
//

import UIKit
import SnapKit

class OnboardingVC: UIPageViewController {
    
    let list: [UIViewController] = {
        return [
            IntroVC(bgColor: .brown, description: "첫번째 설명"),
            IntroVC(bgColor: .blue, description: "두번째 설명"),
            IntroVC(bgColor: .red, description: "세번째 설명")
        ]
    }()
    
    @objc let nextButton = {
        let view = OnboardingNextButton()
        return view
    }()
    
    var currentPageIdx = 0
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        delegate = self
        dataSource = self
        
        guard let firstIntro = list.first else { return }
        setViewControllers([firstIntro], direction: .forward, animated: true)
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(80)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    @objc
    func nextButtonClicked() {
        if currentPageIdx < list.count - 1  {
            currentPageIdx += 1
            setViewControllers([list[currentPageIdx]], direction: .forward, animated: true)
        }
        print(currentPageIdx)
        setButtonLabel(currentIdx: currentPageIdx)
    }
    
    func setButtonLabel(currentIdx: Int) {
        if currentIdx == list.count - 1 {
            nextButton.configureView(text: "complete")
        } else {
            nextButton.configureView(text: "next")
        }
    }
}

extension OnboardingVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = list.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        return previousIndex < 0 ? nil : list[previousIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = list.firstIndex(of: viewController) else { return nil }
        let afterIndex = currentIndex + 1
        return afterIndex >= list.count ? nil : list[afterIndex]
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return list.count
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let first = viewControllers?.first, let index = list.firstIndex(of: first) else { return 0 }
        return index
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentVC = pageViewController.viewControllers?.first {
                for (idx, vc) in list.enumerated() {
                    if vc == currentVC {
                        print(idx, vc)
                        currentPageIdx = idx
                        setButtonLabel(currentIdx: currentPageIdx)
                    }
                }
            }
        }
    }
}
