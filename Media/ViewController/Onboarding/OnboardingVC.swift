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
    
    let nextButton = {
        let view = OnboardingNextButton()
        return view
    }()
    
    let skipButton = {
        let view = UIButton()
        var attString = AttributedString("SKIP")
        attString.font = .systemFont(ofSize: 12, weight: .medium)
        attString.foregroundColor = .white
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        config.baseBackgroundColor = .black
        view.configuration = config
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
        
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        skipButton.addTarget(self, action: #selector(skipButtonClicked), for: .touchUpInside)
    }
    
    @objc
    func nextButtonClicked() {
        if currentPageIdx < list.count - 1  {
            currentPageIdx += 1
            setViewControllers([list[currentPageIdx]], direction: .forward, animated: true)
        }
        print(currentPageIdx)
        skipButtonStatus(currentIdx: currentPageIdx)
        setButtonLabel(currentIdx: currentPageIdx)
    }
    
    @objc
    func skipButtonClicked() {
        if currentPageIdx < list.count - 1  {
            currentPageIdx = list.count - 1
            guard let lastIntro = list.last else { return }
            setViewControllers([lastIntro], direction: .forward, animated: true)
        }
        skipButtonStatus(currentIdx: currentPageIdx)
        setButtonLabel(currentIdx: currentPageIdx)
    }
    
    func setButtonLabel(currentIdx: Int) {
        if currentIdx == list.count - 1 {
            nextButton.configureView(text: "complete")
        } else {
            nextButton.configureView(text: "next")
        }
    }
    
    func skipButtonStatus(currentIdx: Int) {
        skipButton.isHidden = currentIdx == list.count - 1 ? true : false
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
                        skipButtonStatus(currentIdx: currentPageIdx)
                        setButtonLabel(currentIdx: currentPageIdx)
                    }
                }
            }
        }
    }
}
