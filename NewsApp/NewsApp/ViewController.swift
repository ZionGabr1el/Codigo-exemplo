//
//  ViewController.swift
//  NewsApp
//
//  Created by aluno on 21/05/22.
//

import UIKit
import SafariServices
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        fetchTopStories()
    }
        
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
     
    private func fetchTopStories() {APICaller.shared.getTopStories { [weak self] result in
        switch result {
        case .success(let articles):
            self?.articles = articles
            self?.viewModels = articles.compactMap({NewsTableViewCellViewModel(
                                                   title: $0.title,
                                                   subtitle: $0.description ?? "Sem Descrição",
                                                   imageURL: URL(string: $0.urlToImage ?? "")
            )
            })
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        case .failure(let error):
            print(error)}
    }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
    
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath)
    as? NewsTableViewCell else {
        fatalError()
    }
    cell.configure(with: viewModels[indexPath.row])
    return cell
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let article = articles[indexPath.row]
    
    guard let url = URL(string: article.url ?? "") else {
        return
}
    let vc = SFSafariViewController(url: url)
    present(vc, animated: true)

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}
        
        
        /*
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath)
        as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
    }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)

        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150.0
        }


    */

