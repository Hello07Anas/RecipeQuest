//
//  UISetupExtension.swift
//  RecipeQuest
//
//  Created by Anas Salah on 16/08/2024.
//

import UIKit

// MARK: - SetUpView

extension HomeViewController {
    func setupUI() {
        setupSearchBar()
        setupScrollViews()
    }
    
    private func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupScrollViews() {
        let keys = apiParameters.map { $0.0 }
        
        setupScrollView(scrollView1, with: keys, topConstraint: searchBar.bottomAnchor)
        hideScrollViews()
    }
    
    func setupScrollView(_ scrollView: UIScrollView, with titles: [String], topConstraint: NSLayoutYAxisAnchor, padding: CGFloat = 4) {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topConstraint, constant: padding),
            scrollView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        setupButtons(in: scrollView, with: titles)
    }
    
    private func setupButtons(in scrollView: UIScrollView, with titles: [String]) {
        let buttonHeight: CGFloat = 40
        let buttonPadding: CGFloat = 10
        
        var previousButton: UIButton?
        var buttons: [UIButton] = []
        
        for index in 0..<titles.count {
            let button = UIButton(type: .system)
            button.tag = index
            
            button.setTitle(" \(titles[index].capitalized) ", for: .normal)
            button.setTitleColor(.white, for: .normal)
            //selectedFilters.map{ $0.split(separator: "=").last ?? "" }
            let isSeletedFitlers = selectedFilters.filter{ $0.contains(titles[index]) }.count > 0
            
            
            button.backgroundColor = isSeletedFitlers ? .systemMint : .systemCyan
            
            
            button.layer.cornerRadius = 5
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(segmentSelected(_:)), for: .touchUpInside)
            scrollView.addSubview(button)
            buttons.append(button)
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: scrollView.topAnchor),
                button.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
            
            if let previousButton = previousButton {
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: buttonPadding)
                ])
            } else {
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
                ])
            }
            
            previousButton = button
        }
        
        if let lastButton = previousButton {
            NSLayoutConstraint.activate([
                lastButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -buttonPadding)
            ])
            scrollView.contentSize = CGSize(width: lastButton.frame.maxX + buttonPadding, height: buttonHeight)
        }
        
        if scrollView == scrollView1 {
            buttons1 = buttons
        } else {
            buttons2 = buttons
        }
    }
    
    func resetButtonStates() {
        buttons1.forEach { $0.backgroundColor = .systemCyan }
        buttons2.forEach { $0.backgroundColor = .systemCyan }
        selectedButton = nil
    }
    
    func hideScrollViews() {
        scrollView1.alpha = 0
        scrollView1.isHidden = true
        scrollView2.alpha = 0
        scrollView2.isHidden = true
    }
    
    func updateUpConstraintView() {
        let topOffset: CGFloat = {
            if !scrollView2.isHidden {
                return scrollView2.frame.maxY + 16
            } else if !scrollView1.isHidden {
                return scrollView1.frame.maxY + 16
            } else {
                return searchBar.frame.maxY + 16
            }
        }()
        
        upConstaintView.constant = topOffset - view.safeAreaInsets.top
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func handleScrollView1ButtonSelection(_ sender: UIButton) {
        if sender == selectedButton {
            deselectButton(sender)
            return
        }
        
        if sender.tag == 0 {
            selectedFilters = []
        }
        
        print("handleScrollView1ButtonSelection")
        
        buttons1.forEach { $0.backgroundColor = .systemCyan }
        sender.backgroundColor = .systemMint
        selectedButton = sender
        
        currentKey = sender.tag
        
        updateScrollView2(index: sender.tag)
        
        //        print("=======")
        //        print(sender.titleLabel)
        //        print(currentKey)
        //        print("tag is \(sender.tag)")
        //        print("=======")
        
        scrollView2.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.scrollView2.alpha = 1
        }
        updateUpConstraintView()
    }
    
    private func deselectButton(_ button: UIButton) {
        button.backgroundColor = .systemCyan
        selectedButton = nil
        currentKey = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView2.alpha = 0
        }) { _ in
            self.scrollView2.isHidden = true
            self.updateUpConstraintView()
        }
    }
}

