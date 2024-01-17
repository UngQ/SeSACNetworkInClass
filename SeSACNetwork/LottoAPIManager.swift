//
//  LottoAPIManager.swift
//  SeSACNetwork
//
//  Created by ungq on 1/16/24.
//

import Foundation
import Alamofire

struct LottoAPIManager {
    
    func callRequest(number: String, completionHandler: @escaping (String) -> Void) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
        
        // 내부에서 string을 주소로 변환해주는 기능 다 추상화되어있음
        // method를 기입하지 않으면 .get으로 디폴트값 잡아줌
        AF.request(url, method: .get).responseDecodable(of: Lotto.self) { response in
            switch response.result {
            case .success(let success):
                print(success)
                print(success.drwNoDate)
                print(success.drwtNo1)
                
                //almofire안에 dateLabel이 있을 수도 있으니, self 붙여줘야함
//                self.dateLabel.text = success.drwNoDate
//
                completionHandler(success.drwNoDate)
                
                
            case .failure(let failure):
                print("오류 발생")
            }
        }
    }
}


// 클로져
