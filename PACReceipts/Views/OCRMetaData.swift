//
//  OCRMetaData.swift
//  PACReceipts
//
//  Created by kent daniel on 10/9/2023.
//

import Foundation


struct OCRMetaData: Codable {
    let totalAmount: Float?
    let category: String?
    let isTaxDeductible: Bool?
    let date: String?
    let name: String?
}
