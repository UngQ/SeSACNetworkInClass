//
//  LanguageViewController.swift
//  SeSACNetwork
//
//  Created by ungq on 1/17/24.
//

import UIKit

struct Language {
    var code: String
    var language: String
    
//    let languages: [String: String]

}

enum LanguageList {
    static var currentSource: Language = list[0]
    static var currentTarget: Language = list[1]
//    static var currentSourceCode: String = ""
//    static var currentTargetCode: String = ""
    
    static let list: [Language] = [
        Language(code: "ko", language: "한국어"),
        Language(code: "en", language: "영어"),
        Language(code: "ja", language: "일본어"),
        Language(code: "zh-CN", language: "중국어 간체"),
        Language(code: "zh-TW", language: "중국어 번체"),
        Language(code: "vi", language: "베트남어"),
        Language(code: "id", language: "인도네시아어"),
        Language(code: "th", language: "태국어"),
        Language(code: "de", language: "독일어"),
        Language(code: "ru", language: "러시아어"),
        Language(code: "es", language: "스페인어"),
        Language(code: "it", language: "이탈리아어"),
        Language(code: "fr", language: "프랑스어")]
  
    //    static let lists = [
    //    Language(languages: ["ko": "한국어"]),
    //    Language(languages: ["en": "영어"]),
    //    Language(languages: ["ja": "일본어"]),
    //    Language(languages: ["zh-CN": "중국어 간체"]),
    //    Language(languages: ["zh-TW": "중국어 번체"]),
    //    Language(languages: ["vi": "베트남어"]),
    //    Language(languages: ["id": "인도네시아어"]),
    //    Language(languages: ["th": "태국어"]),
    //    Language(languages: ["de": "독일어"]),
    //    Language(languages: ["ru": "러시아어"]),
    //    Language(languages: ["es": "스페인어"]),
    //    Language(languages: ["it": "이탈리아어"]),
    //    Language(languages: ["fr": "프랑스어"])
    //]
}

class LanguageViewController: UIViewController {

    @IBOutlet var languageTableView: UITableView!
    @IBOutlet var changeSourceButton: UIButton!
    @IBOutlet var changeTargetButton: UIButton!
    
    var selectedLanguage: Language = LanguageList.list[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        languageTableView.dataSource = self
        languageTableView.delegate = self
        
 
    }
    
    func changeSourceLanguage() {
        LanguageList.currentSource = selectedLanguage

        }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("CurrentSourceUpdated"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("CurrentTargetUpdated"), object: nil)
    }
    

}



extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LanguageList.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell", for: indexPath) as! LanguageTableViewCell
        
        if LanguageList.list[indexPath.row].language == LanguageList.currentSource.language {
            cell.languageLabel.text = LanguageList.list[indexPath.row].language
            cell.languageLabel.font = .boldSystemFont(ofSize: 16)
            cell.languageLabel.textColor = .systemBlue
            
            return cell
        } else {
            cell.languageLabel.text = LanguageList.list[indexPath.row].language
            cell.languageLabel.font = .systemFont(ofSize: 14)
            cell.languageLabel.textColor = .black
            
            return cell
        }
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguage = LanguageList.list[indexPath.row]
        changeSourceLanguage()
        tableView.reloadData()
    }
    
    
    
}
