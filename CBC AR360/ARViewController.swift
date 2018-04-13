//
//  ARViewController.swift
//  CBC AR360
//
//  Created by Viviane Chan on 2018-04-05.
//  Copyright © 2018 CBC. All rights reserved.
//

import UIKit
import WebKit

class ARViewController: UIViewController {
    
    @IBOutlet var webview: WKWebView!
    var closeButton = UIButton()
    var url = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = WKWebViewConfiguration()
        
        let requestObj = URLRequest(url: NSURL(string: url)! as URL)
        webview.load(requestObj)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        closeButton.backgroundColor = .white
        closeButton.tintColor = .darkGray
        closeButton.layer.cornerRadius = CGFloat(20.0)
        closeButton.layer.shadowColor = UIColor.gray.cgColor
        closeButton.layer.shadowOffset = CGSize(width: 0, height: -3)
        closeButton.layer.shadowOpacity = 0.2
        closeButton.layer.shadowRadius = 5
        closeButton.layer.masksToBounds = false
        closeButton.setImage(#imageLiteral(resourceName: "i_close"), for: .normal)
        self.webview.addSubview(closeButton)

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.trailing, relatedBy: .equal, toItem: self.webview, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: self.webview, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.width, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40).isActive = true
    }
    
    @objc func handleCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            self.webview.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        })
        super.viewWillTransition(to: size, with: coordinator)
    }

    
}


