//
//  BookViewController.swift
//  SeSACNetwork
//
//  Created by ungq on 1/17/24.
//

import UIKit
import Alamofire
import Kingfisher

struct Book: Codable {
    let documents: [Document]
    let meta: Meta
}

struct Document: Codable {
    let authors: [String]
    let contents, datetime, isbn: String
    let price: Int
    let publisher: String
    let salePrice: Int
    let status: String //
    let thumbnail: String
    let title: String
    let translators: [String]
    let url: String

    enum CodingKeys: String, CodingKey {
        case authors, contents, datetime, isbn, price, publisher
        case salePrice = "sale_price"
        case status, thumbnail, title, translators, url
    }
}

struct Meta: Codable {
    let isEnd: Bool
    let pageableCount, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}


class BookViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var bookCollectionView: UICollectionView!
    
    var searchResult: Book? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
}

extension BookViewController {
    func configureView() {
        searchBar.delegate = self
        
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        let cellWidth = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 2)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical

        bookCollectionView.collectionViewLayout = layout
    }
    
    func callRequest(keyword: String) {

        //만약 한글 검색이 안된다면 인코딩 처리
//        let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = "https://dapi.kakao.com/v3/search/book?query=\(keyword)"
        
        let headers: HTTPHeaders = [
            "Authorization": APIKey.kakako,
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: Book.self) { response in
            switch response.result {
            case .success(let success):
                dump(success.documents)
                self.searchResult = success
   
                self.bookCollectionView.reloadData()
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

     
extension BookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult?.documents.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionViewCell", for: indexPath) as! BookCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
        cell.titleLabel.font = .boldSystemFont(ofSize: 16)
        cell.titleLabel.textColor = .white
        cell.titleLabel.numberOfLines = 2
        cell.titleLabel.text = searchResult?.documents[indexPath.row].title
        
        cell.rateLabel.font = .systemFont(ofSize: 12)
        cell.rateLabel.textColor = .white
        cell.rateLabel.textAlignment = .center
        let intFormatter = NumberFormatter()
        intFormatter.numberStyle = .decimal
        let price = searchResult?.documents[indexPath.row].price
        cell.rateLabel.text = "\(intFormatter.string(for: price)!)원"
        
        guard let url = searchResult?.documents[indexPath.row].thumbnail else { return cell }
        let stringURL = URL(string: url)
        cell.imageView.kf.setImage(with: stringURL)
        
        return cell
    }  
}


extension BookViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        callRequest(keyword: searchBar.text!)
    }
}

