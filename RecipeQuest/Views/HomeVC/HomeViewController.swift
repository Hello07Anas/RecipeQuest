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
    
    let searchBar = UISearchBar()
    let scrollView1 = UIScrollView()
    let scrollView2 = UIScrollView()
    
    var buttons1 = [UIButton]()
    var buttons2 = [UIButton]()
    var selectedButton: UIButton?
    
    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var upConstaintView: NSLayoutConstraint!
    @IBOutlet weak var emptyBackgroundImg: UIImageView!
    
    var viewModel = HomeViewModel()
    
    var cancellables: Set<AnyCancellable> = []
    let apiParameters = APIParameters.filters
    var currentKey: Int = 0
    
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
    
    @objc func segmentSelected(_ sender: UIButton) {
        if sender.superview == scrollView1 {
            handleScrollView1ButtonSelection(sender)
        } else if sender.superview == scrollView2 {
            handleScrollView2ButtonSelection(sender)
        }
    }
    
    func updateScrollView2(index: Int) {
        
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
