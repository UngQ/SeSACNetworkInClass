//
//  ViewController.swift
//  SeSACNetwork
//
//  Created by ungq on 1/16/24.
//

import UIKit
import Alamofire

struct Papago: Codable {
    let message: PapagoResult
}

struct PapagoResult: Codable {
    let result: PapagoResultDetail
}

struct PapagoResultDetail: Codable {
    let srcLangType: String
    let tarLangType: String
    let translatedText: String
}

enum LanguageCode: String {
    case source
    case target
}

class ViewController: UIViewController {
    
    @IBOutlet var sourceLanguageButton: UIButton!
    @IBOutlet var exchangeLanguageButton: UIButton!
    @IBOutlet var targetLanguageButton: UIButton!
    
    @IBOutlet var sourceTextView: UITextView!
    @IBOutlet var translateButton: UIButton!
    @IBOutlet var targetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
}

extension ViewController {
    func configureView() {
        sourceTextView.font = .systemFont(ofSize: 18)
        
        targetLabel.numberOfLines = 0
        targetLabel.font = .systemFont(ofSize: 18)
        
        translateButton.setTitle("번역하기", for: .normal)
        
        sourceLanguageButton.titleLabel?.textAlignment = .right
        sourceLanguageButton.setTitle(LanguageList.list[0].language, for: .normal)
        targetLanguageButton.titleLabel?.textAlignment = .left
        targetLanguageButton.setTitle(LanguageList.list[1].language, for: .normal)
        
        translateButton.addTarget(self, action: #selector(translateButtonClicked), for: .touchUpInside)
        
        sourceLanguageButton.addTarget(self, action: #selector(sourceLanguageButtonClicked), for: .touchUpInside)
        targetLanguageButton.addTarget(self, action: #selector(targetLanguageButtonClicked), for: .touchUpInside)
        
        exchangeLanguageButton.addTarget(self, action: #selector(exchangeLanguageButtonClicked), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateSourceLanguageButtonTitle), name: NSNotification.Name("CurrentSourceUpdated"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTargetLanguageButtonTitle), name: NSNotification.Name("CurrentTargetUpdated"), object: nil)
    }
    
    @objc func exchangeLanguageButtonClicked() {
        let temp = LanguageList.currentSource
        LanguageList.currentSource = LanguageList.currentTarget
        LanguageList.currentTarget = temp
        updateSourceLanguageButtonTitle()
        updateTargetLanguageButtonTitle()
    }
    
    @objc func updateSourceLanguageButtonTitle() {
        sourceLanguageButton.setTitle(LanguageList.currentSource.language, for: .normal)
    }
    
    @objc func updateTargetLanguageButtonTitle() {
        targetLanguageButton.setTitle(LanguageList.currentTarget.language, for: .normal)
    }
    
    @objc func sourceLanguageButtonClicked() {

        let vc = storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func targetLanguageButtonClicked() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Language2ViewController") as! Language2ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
 
    /*
     1. 네트워크 통신 단절 상태
     2. API 콜수
     3. 번역 버튼을 연속클릭 방지. 텍스트 비교, 같은 입력값이면 네이버에 전송 안하기 등
     4. 텍스트 비교. 가, 나, 다 등 의미 없으니 두 세글자이상?>
     4. LoadingView
     */
    
    @objc func translateButtonClicked() {
        
        filteredLanguageCode(code: .source)
        filteredLanguageCode(code: .target)
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.clientID,
            "X-Naver-Client-Secret": APIKey.clientSecret
        ]
        
        let parameters: Parameters = [
            "text": sourceTextView.text!,
            "source": LanguageList.currentSource.code,
            "target": LanguageList.currentTarget.code
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseDecodable(of: Papago.self) { response in
            switch response.result {
            case .success(let success):
                print(success)
                
                self.targetLabel.text = success.message.result.translatedText
                
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func filteredLanguageCode(code: LanguageCode) {
        switch code {
        case .source:
            for i in 0...LanguageList.list.count-1 {
                if LanguageList.list[i].language == sourceLanguageButton.currentTitle {
                    LanguageList.currentSource.code = LanguageList.list[i].code
                }
            }
        case .target:
            for i in 0...LanguageList.list.count-1 {
                if LanguageList.list[i].language == targetLanguageButton.currentTitle {
                    LanguageList.currentTarget.code = LanguageList.list[i].code
                }
            }
        }
    }
}
