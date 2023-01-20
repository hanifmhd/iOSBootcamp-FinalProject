//
//  FavoriteViewController.swift
//  NewsMVVM Final
//
//  Created by Muhammad Hanif on 20/01/23.
//

import UIKit
import RxSwift
import RealmSwift

class FavoriteViewController: UITableViewController {
    
    private var listNewsViewModel: ListNewsViewModel?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateNews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
          if let detailNewsViewController = segue.destination as? DetailNewsViewController {
              detailNewsViewController.news = sender as? News
          }
        }
    }
    
    private func populateNews() {
        lazy var realm = try! Realm()
        let news = realm.objects(News.self)
        self.listNewsViewModel = ListNewsViewModel(Array(news))
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = self.listNewsViewModel?.newsAt(indexPath.row)
        guard let news = cellData?.articles else { return }
        performSegue(withIdentifier: "show", sender: news)
    }
}

// MARK: - Table view data source
extension FavoriteViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listNewsViewModel = listNewsViewModel else {
            return 0
        }
        if listNewsViewModel.newsViewModel.count == 0 {
            self.tableView.setEmptyMessage("There is no data")
        } else {
            self.tableView.restore()
        }
        return listNewsViewModel.newsViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell else {
            fatalError("NewsTableViewCell is not found")
        }
        let cellData = self.listNewsViewModel?.newsAt(indexPath.row)
        cellData?.title
            .asDriver(onErrorJustReturn: "no title found")
            .drive(onNext: { titleText in
                cell.titleLabel.text = titleText
            })
            .disposed(by: disposeBag)
        cellData?.description
            .asDriver(onErrorJustReturn: "no description found")
            .drive(onNext: { descriptionText in
                cell.descriptionLabel.text = descriptionText
            })
            .disposed(by: disposeBag)
        cell.favoriteButton.tintColor = .systemRed
        cell.favoriteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(delete(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func delete(sender: UIButton){
        let cellData = self.listNewsViewModel?.newsAt(sender.tag)
        guard let news = cellData?.articles else { return }
        _ = news.title
        lazy var realm = try! Realm()
        try! realm.write {
            realm.delete(news)
        }
        self.listNewsViewModel?.newsViewModel.remove(at: sender.tag)
        self.tableView.reloadData()
        
        let alert = UIAlertController(title: "Remove from favorite", message: "\(news.title) is removed from favorite.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
