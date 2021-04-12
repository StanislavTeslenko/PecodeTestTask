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
        
        tableView.tableFooterView = UIView()
        
        tableView.refreshControl = refreshControl
        refreshControl.beginRefreshing()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        DataManager.shared.delegate = self
        DataManager.shared.loadFirstPage()
        
    }
    
    @objc func refresh() {
        DataManager.shared.loadFirstPage()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func dataReady() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.cellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotNewsCell", for: indexPath)

        cell.textLabel?.text = DataManager.shared.cellModel[indexPath.row].source
        
        if indexPath.row == DataManager.shared.cellModel.count - 2 {
            refreshControl.beginRefreshing()
            DataManager.shared.loadNextPage()
        }

        return cell
    }
    
//    let cellMarginSize :CGFloat  = 4.0
//    func tableView(_ tableView: UITableView,
//             estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//       // Choose an appropriate default cell size.
//       var cellSize = UITableView.automaticDimension
//
//       // The first cell is always a title cell. Other cells use the Basic style.
//       if indexPath.row == 0 {
//          //Title cells consist of one large title row and two body text rows.
//          let largeTitleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
//          let bodyFont = UIFont.preferredFont(forTextStyle: .body)
//
//          // Get the height of a single line of text in each font.
//          let largeTitleHeight = largeTitleFont.lineHeight + largeTitleFont.leading
//          let bodyHeight = bodyFont.lineHeight + bodyFont.leading
//
//          // Sum the line heights plus top and bottom margins to get the final height.
//          let titleCellSize = largeTitleHeight + (bodyHeight * 2.0) + (cellMarginSize * 2)
//
//          // Update the estimated cell size.
//          cellSize = titleCellSize
//       }
//
//       return cellSize
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}

