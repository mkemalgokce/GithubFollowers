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
}
