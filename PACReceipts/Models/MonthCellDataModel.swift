//
//  MonthCellDataModel.swift
//  PACReceipts
//
//  Created by kent daniel on 10/9/2023.
//

import Foundation


struct MonthCellDataModel : Hashable {
    let month:String
    let receiptsCount:Int
    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
