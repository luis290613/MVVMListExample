//
//  ListViewController.swift
//  MVVMExample
//
//  Created by Luis Diego Ruiz Bautista on 7/07/23.
//

import UIKit
import Combine

class ListViewController: UIViewController {
    
    private var viewModel: ListViewModel!
    private var customView: ListView!
    
    private var cancellables = Set<AnyCancellable>()
    private var posts: [ResponseGet] = []
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupTableView()
        setupBindings()
        fetchData()
    }
    
    override func loadView() {
        super.loadView()
        customView = ListView()
        view = customView
        
        // MARK: Position custom frame
        //customView = ListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
        //view.addSubview(customView)
    }
    
    private func setupViewModel() {
        //viewModel = ListViewModel(dataSource: ListDataSource())
        viewModel = ListViewModel(dataSource: ListDataSourceMock())
    }
    
    // MARK: Subscribe notifications
    private func setupBindings() {
        viewModel.postsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] posts in
                self?.posts = posts
                self?.customView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: Pull information
    private func fetchData() {
        viewModel.fetchData()
        viewModel.postData()
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
        return cell
    }
}
