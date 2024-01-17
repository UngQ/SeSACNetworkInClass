//
//  MarketViewViewController.swift
//  SeSACNetwork
//
//  Created by ungq on 1/16/24.
//

import UIKit
import Alamofire

struct Upbit: Codable {
    let market: String
    let korean_name: String
    let english_name: String
}

class MarketViewViewController: UIViewController {
    
    @IBOutlet var marketTableView: UITableView!
    
    var list: [Upbit] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callRequest()
        configureTableView()
    }
    
    func configureTableView() {
        marketTableView.delegate = self
        marketTableView.dataSource = self
    }
    
    func callRequest() {
        let url = "https://api.upbit.com/v1/market/all"
        
        
        //alamofire validate 는 디폴트 statusCode가 200~299
        //validate(statusCode: 200..<300)
        //범위를 500까지 잡아서, success로 처리 한다음
        //상태 코드에 따른 오류처리를 해줄 수도 있음
        
        //method는 디폴트 .get
        AF.request(url, method: .get)
            .validate(statusCode: 200..<309)
            .responseDecodable(of: [Upbit].self) { response in
            
            switch response.result {
            case .success(let success):
                
                dump(success)
                    
                
                //상태 코드에 따른 처리
                if response.response?.statusCode == 200 {
                    self.list = success
                    
                    self.marketTableView.reloadData()
                }
                
                self.list = success
                
                //데이터가 오는 시간이 있기 때문에, 받아 오는 시점에 테이블뷰 갱신
                self.marketTableView.reloadData()
                
            case .failure(let failure):
                print("오류 발생")
            }
        }
    }
}


extension MarketViewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marketCell")!
        
        let data = list[indexPath.row]
        cell.textLabel?.text = data.korean_name
        cell.detailTextLabel?.text = data.market
        
        return cell
    }
}
