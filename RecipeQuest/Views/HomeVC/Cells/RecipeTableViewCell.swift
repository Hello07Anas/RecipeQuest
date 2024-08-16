//
//  RecipeTableViewCell.swift
//  RecipeQuest
//
//  Created by Anas Salah on 15/08/2024.
//

import UIKit
import Kingfisher
import WebKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeSourceBtn: UIButton!
    
    private var urlString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageStyling.style(image: recipeImg)
    }
    
    
    @IBAction func recipeSourceBtnTapped(_ sender: Any) {
        if urlString.contains(".com"){
            guard let urlObject = URL(string: "https://www.\(urlString)") else {
                showAlert()
                return
            }
            let urlString = urlObject.absoluteString
            
            openURLInWebView(urlString: urlString)
            
            return
        } else if !urlString.contains(".com") {
            guard let urlObject = URL(string: "https://www.\(urlString).com") else {
                showAlert()
                return
            }
            let urlString = urlObject.absoluteString
            
            openURLInWebView(urlString: urlString)
            
        } else {
            showAlert()
        }
    }
    
    func setup(with recipe: Recipe) {
        urlString = recipe.source
        recipeName.text = recipe.label
        //recipeSourceBtn.setTitle(recipe.source, for: .normal)
        recipeSourceBtn.setTitle(urlString, for: .normal)
        let placeholderImage = UIImage(named: "recipeImg")
        if let imageURL = URL(string: recipe.image) {
            recipeImg.kf.setImage(with: imageURL, placeholder: placeholderImage)
        } else {
            recipeImg.image = placeholderImage
        }
    }
    
    private func showAlert() {
        guard let viewController = findViewController() else { return }
        
        let alertController = UIAlertController(
            title: "Sorry",
            message: "Link will be available soon",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alertController, animated: true, completion: nil)
    }
}


// MARK: - WebView
extension RecipeTableViewCell {
    private func openURLInWebView(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        guard let viewController = findViewController() else { return }
        
        let webViewController = UIViewController()
        webViewController.modalPresentationStyle = .fullScreen
        
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        webViewController.view.addSubview(navigationBar)
        
        let navigationItem = UINavigationItem()
        navigationItem.title = "RecipeQuest"
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(dismissWebViewController)
        )
        navigationItem.leftBarButtonItem = backButton
        
        navigationBar.setItems([navigationItem], animated: false)
        
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewController.view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: webViewController.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: webViewController.view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: webViewController.view.trailingAnchor),
            
            webView.leadingAnchor.constraint(equalTo: webViewController.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: webViewController.view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: webViewController.view.bottomAnchor)
        ])
        
        webView.load(URLRequest(url: url))
        
        viewController.present(webViewController, animated: true, completion: nil)
    }
    
    @objc private func dismissWebViewController() {
        if let viewController = findViewController() {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    private func findViewController() -> UIViewController? {
        var viewController: UIViewController? = nil
        var view: UIView? = self.superview
        
        while view != nil {
            if let responder = view?.next as? UIViewController {
                viewController = responder
                break
            }
            view = view?.superview
        }
        
        return viewController
    }
}
