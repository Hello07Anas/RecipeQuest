//
//  HomeViewController.swift
//  RecipeQuest
//
//  Created by Anas Salah on 13/08/2024.
//

import UIKit
import Combine
import Kingfisher

class HomeViewController: UIViewController, UISearchBarDelegate {
    
    private let searchBar = UISearchBar()
    private let scrollView1 = UIScrollView()
    private let scrollView2 = UIScrollView()
    
    private var buttons1 = [UIButton]()
    private var buttons2 = [UIButton]()
    private var selectedButton: UIButton?
    
    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var upConstaintView: NSLayoutConstraint!
    
    private var viewModel = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    private let apiParameters = APIParameters.all
    private var currentKey: String?
    private var recipes: [Recipe] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        searchBar.delegate = self

        setupUI()
        
        viewModel.$recipes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] recipes in
                self?.recipes = recipes
                self?.recipesTableView.reloadData()
            }
            .store(in: &cancellables)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUpConstraintView()
    }
    
    @objc private func segmentSelected(_ sender: UIButton) {
        if sender.superview == scrollView1 {
            handleScrollView1ButtonSelection(sender)
        } else if sender.superview == scrollView2 {
            handleScrollView2ButtonSelection(sender)
        }
    }
    
    private func updateScrollView2() {
        guard let key = currentKey, let values = apiParameters[key] else {
            return
        }
        
        buttons2.forEach { $0.removeFromSuperview() }
        buttons2.removeAll()
        
        setupScrollView(scrollView2, with: values, topConstraint: scrollView1.bottomAnchor, padding: 10)
    }
    
    private func handleScrollView2ButtonSelection(_ sender: UIButton) {
        if sender.backgroundColor == .systemRed {
            sender.backgroundColor = .systemBlue
        } else {
            buttons2.forEach { $0.backgroundColor = .systemBlue }
            sender.backgroundColor = .systemRed
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        scrollView1.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.scrollView1.alpha = 1
        }
        updateUpConstraintView()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView1.alpha = 0
            self.scrollView2.alpha = 0
        }) { _ in
            self.hideScrollViews()
            self.resetButtonStates()
            self.updateUpConstraintView()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        
        print("Search button clicked with term: \(searchTerm)")
        viewModel.fetchRecipes(searchTerm: searchTerm)
        
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        let recipe = recipes[indexPath.row]
        cell.setup(with: recipe)
        
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedRecipe = recipes[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "RecipeDetailViewController") as? RecipeDetailViewController {
            let detailViewModel = RecipeDetailViewModel(recipe: selectedRecipe)
            detailVC.viewModel = detailViewModel
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}






// MARK: - SetUpView

extension HomeViewController {
    private func setupUI() {
        setupSearchBar()
        setupScrollViews()
    }
    
    private func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupScrollViews() {
        let keys = Array(apiParameters.keys)
        
        setupScrollView(scrollView1, with: keys, topConstraint: searchBar.bottomAnchor)
        
        hideScrollViews()
    }
    
    private func setupScrollView(_ scrollView: UIScrollView, with titles: [String], topConstraint: NSLayoutYAxisAnchor, padding: CGFloat = 0) {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let topPadding: CGFloat = scrollView == scrollView1 ? 8 : padding
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topConstraint, constant: topPadding),
            scrollView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        setupButtons(in: scrollView, with: titles)
    }
    /*
    private func setupButtons(in scrollView: UIScrollView, with titles: [String]) {
        let buttonHeight: CGFloat = 40
        let buttonPadding: CGFloat = 10
        
        var previousButton: UIButton?
        var buttons: [UIButton] = []
        
        for title in titles {
            let button = UIButton(type: .system)
            button.setTitle(" \(title) ", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(segmentSelected(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
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
    */
    
    private func setupButtons(in scrollView: UIScrollView, with titles: [String]) {
        let buttonHeight: CGFloat = 40
        let buttonPadding: CGFloat = 10
        
        var previousButton: UIButton?
        var buttons: [UIButton] = []
        
        for title in titles {
            let button = UIButton(type: .system)
            button.setTitle(" \(title) ", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemCyan // Change to systemCyan
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(segmentSelected(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
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

    private func selectButtonInScrollView1(_ sender: UIButton) {
        buttons1.forEach { $0.backgroundColor = .systemCyan } // Change to systemCyan
        sender.backgroundColor = .systemMint // Change to systemMint
        selectedButton = sender
        
        currentKey = sender.titleLabel?.text?.trimmingCharacters(in: .whitespaces)
        updateScrollView2()
        
        scrollView2.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.scrollView2.alpha = 1
        }
        updateUpConstraintView()
    }

    
    private func resetButtonStates() {
        buttons1.forEach { $0.backgroundColor = .systemBlue }
        buttons2.forEach { $0.backgroundColor = .systemBlue }
        selectedButton = nil
    }
    
    private func hideScrollViews() {
        scrollView1.alpha = 0
        scrollView1.isHidden = true
        scrollView2.alpha = 0
        scrollView2.isHidden = true
    }
    
    private func updateUpConstraintView() {
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
    
    private func handleScrollView1ButtonSelection(_ sender: UIButton) { 
        if sender.backgroundColor == .systemRed {
            resetScrollView1()
        } else {
            selectButtonInScrollView1(sender)
        }
    }
    
    private func resetScrollView1() {
        buttons1.forEach { $0.backgroundColor = .systemBlue }
        selectedButton = nil
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView2.alpha = 0
        }) { _ in
            self.scrollView2.isHidden = true
            self.updateUpConstraintView()
        }
        
        updateUpConstraintView()
    }
}

// Desgin Pattern is A proven soulution to a common problem

/*
 الحمد لله علي كل حال
 
 15 Aug
 
 1. Network Call and print data in console " when click serach feach data.
 2. desgin cell of table.
 3. desgin details.
 4. presnt data in table.
 5. navigate when click on table to details and present its data.
 6. clean and maintain code as possible as could.
 
 */
