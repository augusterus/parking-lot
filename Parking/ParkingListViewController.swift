//
//  ParkingListViewController.swift
//  Parking
//
//  Created by 王鴻翔 on 2019/1/28.
//  Copyright © 2019 王鴻翔. All rights reserved.
//

import UIKit
import Alamofire

class ParkingListViewController: UIViewController {

    let baseURL = URL(string: "http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-000225-002")!
    var parkingList = [Parking]()
    var searchParkingList = [Parking]()
    
    let dao = ParkingDao.shared
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        if dao.getRowCount() == 0 {
            self.downloadParking {
                self.dao.insertTable(list: self.parkingList, completion: {
                    self.tableView.reloadData()
                })
            }
        } else {
            if let list = dao.queryTable() {
                parkingList = list
                self.tableView.reloadData()
            }
        }
        navigationController?.navigationBar.prefersLargeTitles = false
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "ParkingListCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    func downloadParking(completion: @escaping () -> Void) {
        Alamofire.request(baseURL).validate().responseJSON { (response) in
            guard response.result.isSuccess, let json = response.result.value as? [String: Any] else { return }
            
            guard let result = json["result"] as? [String: Any],
                let records = result["records"] as? [[String: Any]] else { return }
            
            for record in records {
                let id = record["ID"] as? String ?? ""
                let area = record["AREA"] as? String ?? ""
                let name = record["NAME"] as? String ?? ""
                let type = record["TYPE"] as? String ?? ""
                let summary = record["SUMMARY"] as? String ?? ""
                let address = record["ADDRESS"] as? String ?? ""
                let tel = record["TEL"] as? String ?? ""
                let payex = record["PAYEX"] as? String ?? ""
                let serviceTime = record["SERVICETIME"] as? String ?? ""
                let tw97X = record["TW97X"] as? String ?? ""
                let tw97Y = record["TW97Y"] as? String ?? ""
                let totalCar = record["TOTALCAR"] as? String ?? ""
                let totalMotor = record["TOTALMOTOR"] as? String ?? ""
                let totalBike = record["TOTALBIKE"] as? String ?? ""
                
                self.parkingList.append(Parking(id: id, area: area, name: name, type: type, summary: summary, address: address, tel: tel, payex: payex, servicetime: serviceTime, tw97X: tw97X, tw97Y: tw97Y, totalcar: totalCar, totalmotor: totalMotor, totalbike: totalBike))
             }
            completion()
        }
    }
}

extension ParkingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if navigationItem.searchController?.isActive ?? false {
            return searchParkingList.count
        } else {
            return parkingList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ParkingListCell else { return UITableViewCell() }
        
        if navigationItem.searchController?.isActive ?? false {
            let data = searchParkingList[indexPath.row]
            cell.parking = data
        } else {
            let data = parkingList[indexPath.row]
            cell.parking = data
        }
        
        return cell
    }
}

extension ParkingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "parking_detail") as! ParkingDetailViewController
        if navigationItem.searchController?.isActive ?? false {
            vc.parking = searchParkingList[indexPath.row]
        } else {
            vc.parking = parkingList[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ParkingListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        searchParkingList = parkingList.filter({ $0.area.contains(searchText.lowercased()) || $0.name.contains(searchText.lowercased()) })
        
        tableView.reloadData()
    }
}
