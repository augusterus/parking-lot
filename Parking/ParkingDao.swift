//
//  ParkingDao.swift
//  Parking
//
//  Created by 王鴻翔 on 2019/1/28.
//  Copyright © 2019 王鴻翔. All rights reserved.
//
//  https://github.com/stephencelis/SQLite.swift

import Foundation
import SQLite

class ParkingDao: NSObject {
    
    static let shared = ParkingDao()
    
    var db: Connection?
    let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    let parking = Table("Parking")
    let id = Expression<String>("id")
    let area = Expression<String>("area")
    let name = Expression<String>("name")
    let type = Expression<String>("type")
    let summary = Expression<String>("summary")
    let address = Expression<String>("address")
    let tel = Expression<String>("tel")
    let payex = Expression<String>("pay_ex")
    let servicetime = Expression<String>("service_time")
    let tw97X = Expression<String>("tw97_x")
    let tw97Y = Expression<String>("tw97_y")
    let totalcar = Expression<String>("total_car")
    let totalmotor = Expression<String>("total_motor")
    let totalbike = Expression<String>("total_bike")
    
    private override init() {
        super.init()
        do {
            try db = Connection(filePath + "/db.sqlite3")
            self.createTable()
            print(filePath)
        } catch {
            print("db connection error")
        }
    }
    
    func createTable() {
        guard let db = db else { return }
        do {
            try db.run(parking.create(block: { (t) in
                t.column(id, primaryKey: true)
                t.column(area)
                t.column(name)
                t.column(type)
                t.column(summary)
                t.column(address)
                t.column(tel)
                t.column(payex)
                t.column(servicetime)
                t.column(tw97X)
                t.column(tw97Y)
                t.column(totalcar)
                t.column(totalmotor)
                t.column(totalbike)
            }))
        } catch {
            print("table create fail")
        }
    }
    
    func insertTable(list: [Parking], completion: @escaping () -> Void) {
        guard let db = db else { return }
        
        for data in list {
            let insert = parking.insert(id <- data.id,
                                        area <- data.area,
                                        name <- data.name,
                                        type <- data.type,
                                        summary <- data.summary,
                                        address <- data.address,
                                        tel <- data.tel,
                                        payex <- data.payex,
                                        servicetime <- data.servicetime,
                                        tw97X <- data.tw97X,
                                        tw97Y <- data.tw97Y,
                                        totalcar <- data.totalcar,
                                        totalmotor <- data.totalmotor,
                                        totalbike <- data.totalbike)
            do {
                try db.run(insert)
            } ///catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
                ///print("constraint failed: \(message), in \(statement?.description)")
         //   }
        catch let error {
                print("insertion failed: \(error)")
            }
        }
        completion()
    }
    
    func queryTable() -> [Parking]? {
        guard let db = db else { return nil }
        var list =  [Parking]()
        
        do {
            for data in try db.prepare(parking) {
                let id = data[self.id]
                let area = data[self.area]
                let name = data[self.name]
                let type = data[self.type]
                let summary = data[self.summary]
                let address = data[self.address]
                let tel = data[self.tel]
                let payex = data[self.payex]
                let servicetime = data[self.servicetime]
                let tw97X = data[self.tw97X]
                let tw97Y = data[self.tw97Y]
                let totalcar = data[self.totalcar]
                let totalmotor = data[self.totalmotor]
                let totalbike = data[self.totalbike]
                
                list.append(Parking(id: id, area: area, name: name, type: type, summary: summary, address: address, tel: tel, payex: payex, servicetime: servicetime, tw97X: tw97X, tw97Y: tw97Y, totalcar: totalcar, totalmotor: totalmotor, totalbike: totalbike))
            }
            return list
        } catch {
            print("query fail")
            return nil
        }
    }
    
    func getRowCount() -> Int {
        guard let db = db else { return 0 }
        do {
            let count = try db.scalar(parking.count)
            return count
        } catch {
            print("get row count error")
            return 0
        }
    }
}
