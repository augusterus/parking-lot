//
//  Parking.swift
//  Parking
//
//  Created by 王鴻翔 on 2019/1/28.
//  Copyright © 2019 王鴻翔. All rights reserved.
//

import Foundation

struct Parking {
    let id: String
    let area: String
    let name: String
    let type: String
    let summary: String
    let address: String
    let tel: String
    let payex: String
    let servicetime: String
    let tw97X: String
    let tw97Y: String
    let totalcar: String
    let totalmotor: String
    let totalbike: String
    
    init(id: String, area: String, name: String, type: String, summary: String, address: String, tel: String, payex: String, servicetime: String, tw97X: String, tw97Y: String, totalcar: String, totalmotor: String, totalbike: String) {
        self.id = id
        self.area = area
        self.name = name
        self.type = type
        self.summary = summary
        self.address = address
        self.tel = tel
        self.payex = payex
        self.servicetime = servicetime
        self.tw97X = tw97X
        self.tw97Y = tw97Y
        self.totalcar = totalcar
        self.totalmotor = totalmotor
        self.totalbike = totalbike
    }
}
