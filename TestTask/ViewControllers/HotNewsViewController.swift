//
//  HotNewsViewController.swift
//  TestTask
//
//  Created by Stanislav Teslenko on 12.04.2021.
//

import UIKit

class HotNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell
        tableView.register(UINib(nibName: "HotNewsCell", bundle: nil), forCellReuseIdentifier: "HotNewsCell")
        
        // Set AutomaticDimension for cell
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        // Clear TableView footer
        tableView.tableFooterView = UIView()
        
        // Create RefreshControl
        tableView.refreshControl = refreshControl
        refreshControl.beginRefreshing()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        // Create Datamanager delegate and send command to load data from network
        DataManager.shared.delegate = self
        DataManager.shared.loadFirstPage()
    }
    
    // RefreshControl action
    @objc private func refresh() {
        DataManager.shared.loadFirstPage()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // Network data loaded (DataManagerDelegate)
    func dataReady() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    private func loadNextPage() {
        refreshControl.beginRefreshing()
        DataManager.shared.loadNextPage()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.cellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotNewsCell", for: indexPath) as? HotNewsCell else {
            fatalError("Error dequeuing cell")
        }
        
        let cellModel = DataManager.shared.cellModel[indexPath.row]
        cell.configure(with: cellModel)
        
        // Load next page from network if table scrolling down
        if indexPath.row == DataManager.shared.cellModel.count - 2 {
            loadNextPage()
        }
        
        // Force update cell layout
        cell.layoutIfNeeded()

        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let urlString = DataManager.shared.cellModel[indexPath.row].url else {return}
        performSegue(withIdentifier: "DetailsViewControllerSegue", sender: urlString)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "DetailsViewControllerSegue" else {return}
        
        let destination = segue.destination as! DetailsViewController
        destination.urlString = sender as! String
    }
    


}

