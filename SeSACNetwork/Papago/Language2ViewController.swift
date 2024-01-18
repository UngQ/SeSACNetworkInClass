//
//  LanguageViewController.swift
//  SeSACNetwork
//
//  Created by ungq on 1/17/24.
//

import UIKit

class Language2ViewController: UIViewController {

    @IBOutlet var languageTableView: UITableView!
    
    var selectedLanguage: Language = LanguageList.list[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        languageTableView.dataSource = self
        languageTableView.delegate = self
    }
    
    func changeTargetLanguage() {
        LanguageList.currentTarget = selectedLanguage

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("CurrentTargetUpdated"), object: nil)
    }
}



extension Language2ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LanguageList.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell", for: indexPath) as! LanguageTableViewCell
        
        if LanguageList.list[indexPath.row].language == LanguageList.currentTarget.language {
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
        changeTargetLanguage()
        tableView.reloadData()

    }
}
