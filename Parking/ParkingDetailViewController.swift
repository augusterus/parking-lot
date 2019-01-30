//
//  ParkingDetailViewController.swift
//  Parking
//
//  Created by 王鴻翔 on 2019/1/28.
//  Copyright © 2019 王鴻翔. All rights reserved.
//

import UIKit
import MapKit

class ParkingDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    var parking: Parking!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupMap()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupMap() {
        let marker = MKPointAnnotation()
        marker.title = parking.name
        marker.subtitle = parking.address
        marker.coordinate = TWD97ToWGS84(x: Double(parking.tw97X) ?? 0, y: Double(parking.tw97Y) ?? 0)
        mapView.centerCoordinate = marker.coordinate
        mapView.region = MKCoordinateRegion(center: marker.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
        mapView.addAnnotation(marker)
    }
    
    //  https://github.com/twofishsman/Convert_TWD97_to_WGS84
    func TWD97ToWGS84(x: Double, y: Double) -> CLLocationCoordinate2D {
        var x: Double = x
        var y: Double = y
        
        let a = 6378137.0
        let b = 6356752.314245
        
        let lng0 = 121 * Double.pi / 180
        let k0 = 0.9999
        let dx = 250000.0
        let dy = 0.0
        let e = pow((1 - pow(b, 2) / pow(a, 2)), 0.5)
        x = x - dx
        y = y - dy
        let mm = y / k0
        let mu = mm / (a * (1.0 - pow(e, 2) / 4.0 - 3 * pow(e, 4) / 64.0 - 5 * pow(e, 6) / 256.0))
        let e1 = (1.0 - pow((1.0 - pow(e, 2)), 0.5)) / (1.0 + pow((1.0 - pow(e, 2)), 0.5))
        let j1 = (3 * e1 / 2 - 27 * pow(e1, 3) / 32.0)
        let j2 = (21 * pow(e1, 2) / 16 - 55 * pow(e1, 4) / 32.0)
        let j3 = (151 * pow(e1, 3) / 96.0)
        let j4 = (1097 * pow(e1, 4) / 512.0)
        let fp = mu + j1 * sin(2 * mu) + j2 * sin(4 * mu) + j3 * sin(6 * mu) + j4 * sin(8 * mu)
        let e2 = pow((e * a / b), 2)
        let c1 = pow(e2 * cos(fp), 2)
        let t1 = pow(tan(fp), 2)
        let r1 = a * (1 - pow(e, 2)) / pow((1 - pow(e, 2) * pow(sin(fp), 2)), (3.0 / 2.0))
        let n1 = a / pow((1 - pow(e, 2) * pow(sin(fp), 2)), 0.5)
        
        let dd = x / (n1 * k0)
        let q1 = n1 * tan(fp) / r1
        let q2 = (pow(dd, 2) / 2.0)
        let q3 = (5 + 3 * t1 + 10 * c1 - 4 * pow(c1, 2) - 9 * e2) * pow(dd, 4) / 24.0
        let q4 = (61 + 90 * t1 + 298 * c1 + 45 * pow(t1, 2) - 3 * pow(c1, 2) - 252 * e2) * pow(dd, 6) / 720.0
        var lat = fp - q1 * (q2 - q3 + q4)
        let q5 = dd
        let q6 = (1 + 2 * t1 + c1) * pow(dd, 3) / 6
        let q7 = (5 - 2 * c1 + 28 * t1 - 3 * pow(c1, 2) + 8 * e2 + 24 * pow(t1, 2)) * pow(dd, 5) / 120.0
        var lng = lng0 + (q5 - q6 + q7) / cos(fp)
        
        // output WGS84
        lat = (lat * 180) / Double.pi
        lng = (lng * 180) / Double.pi
        
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}

extension ParkingDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "停車場名稱"
            cell.detailTextLabel?.text = parking.name
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "區域"
            cell.detailTextLabel?.text = parking.area
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "營業時間"
            cell.detailTextLabel?.text = parking.servicetime
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "地址(點擊導航)"
            cell.detailTextLabel?.text = parking.address
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension ParkingDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 3 {
            let placeMark = MKPlacemark(coordinate: TWD97ToWGS84(x: Double(parking.tw97X) ?? 0, y: Double(parking.tw97Y) ?? 0))
            let mapItem = MKMapItem(placemark: placeMark)
            mapItem.name = parking.name
            mapItem.openInMaps(launchOptions: nil)
        }
    }
}
