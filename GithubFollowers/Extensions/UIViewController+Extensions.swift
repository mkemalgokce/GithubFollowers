//
//  UIViewController+Extensions.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import UIKit

extension UIViewController {
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func presentGFAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertController = GFAlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)
            
            alertController.modalPresentationStyle = .overFullScreen
            alertController.modalTransitionStyle = .crossDissolve
            self.present(alertController, animated: true)
            
        }
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = self.view.center
            activityIndicator.startAnimating()
            
            self.view.addSubview(activityIndicator)
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            if let activityIndicator = self.view.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
}
