//
//  ViewController.swift
//  SeSACNetwork
//
//  Created by ungq on 1/16/24.
//

import UIKit
import Alamofire


class ViewController: UIViewController {

    @IBOutlet var sourceTextView: UITextView!
    @IBOutlet var translateButton: UIButton!
    @IBOutlet var targetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        translateButton.addTarget(self, action: #selector(translateButtonClicked), for: .touchUpInside)
        
        
        
    }
    
    
    @objc func translateButtonClicked() {
        let url = "https://openapi.naver.com/v1/papago/n2mt"

        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "3uSf2p3UPLOwjPI2hk8p",
            "X-Naver-Client-Secret": "CRBmYdR38E"
        ]
        
        let parameters: Parameters = [
            "text": sourceTextView.text!,
            "source": "ko",
            "target": "en"
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers)
        
        
        
        
        
    }
    



}

