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
    @IBOutlet weak var emptyBackgroundImg: UIImageView!
    
    private var viewModel = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    private let apiParameters = APIParameters.filters
    private var currentKey: Int = 0
    
    var selectedFilters: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        searchBar.delegate = self
        
        setupUI()
        
        viewModel.$recipes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] recipes in
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
    
    private func updateScrollView2(index: Int) {
                
        let values = apiParameters[index].1
        //print("values is \(values)")
        buttons2.forEach { $0.removeFromSuperview() }
        buttons2.removeAll()
        
        setupScrollView(scrollView2, with: values, topConstraint: scrollView1.bottomAnchor, padding: 10)
    }
    
    private func handleScrollView2ButtonSelection(_ sender: UIButton) {
        if sender.backgroundColor == .systemMint {
            sender.backgroundColor = .systemCyan
        } else {
            //buttons2.forEach { $0.backgroundColor = .systemCyan }
            sender.backgroundColor = .systemMint
        }
        
        let value = "\(apiParameters[currentKey].0)=\(apiParameters[currentKey].1[sender.tag])"
        
        if selectedFilters.contains(value) {
            selectedFilters.removeAll { $0 == value }
        } else {
            selectedFilters.append(value)
        }
        print(selectedFilters)
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
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
    
        let endPoint = selectedFilters.joined(separator: "&")
        
        viewModel.fetchRecipes(query: query, endPoint: endPoint)

        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView1.alpha = 0
            self.scrollView2.alpha = 0
        }) { _ in
            self.scrollView1.isHidden = true
            self.scrollView2.isHidden = true
            
            self.updateUpConstraintView()
        }

        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.clearRecipes()
            recipesTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateViewVisibility()
        return viewModel.recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        let recipe = viewModel.recipes[indexPath.row]
        cell.setup(with: recipe)
        
        if indexPath.row == viewModel.recipes.count - 1 {
            viewModel.getNextRecipes()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedRecipe = viewModel.recipes[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "RecipeDetailViewController") as? RecipeDetailViewController {
            let detailViewModel = RecipeDetailViewModel(recipe: selectedRecipe)
            detailVC.viewModel = detailViewModel
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func updateViewVisibility() {
        if viewModel.recipes.isEmpty {
            emptyBackgroundImg.isHidden = false
            recipesTableView.isHidden = true
        } else {
            emptyBackgroundImg.isHidden = true
            recipesTableView.isHidden = false
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
    
    private func setupScrollView(_ scrollView: UIScrollView, with titles: [String], topConstraint: NSLayoutYAxisAnchor, padding: CGFloat = 4) {
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
    
    private func resetButtonStates() {
        buttons1.forEach { $0.backgroundColor = .systemCyan }
        buttons2.forEach { $0.backgroundColor = .systemCyan }
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
