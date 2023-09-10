//
//  MetaDataExtractor.swift
//  PACReceipts
//
//  Created by kent daniel on 10/9/2023.
//

import Foundation
import ChatGPTSwift

let openAIKey = "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"
let api  = ChatGPTAPI(apiKey: openAIKey)

func getOCRMetaData(from ocrText: String , categories: [String] , occupation: String)  async -> OCRMetaData?  {
    let systext = """
        Your client works as \(occupation)
        You are a tax consultant eager to help customers file their tax returns.
        You have an input of a receipt OCR and a categories array. You judge which category the receipt fits in best with and respond in the JSON format of: {totalAmount:, category:, isTaxDeductible:, date:(dd/mm/yyyy), name:}
        """
    do  {
        let response = try await api.sendMessage(text: ocrText  +  "\n categories that can be chosen : [\(categories.joined(separator: ", "))]",
                                                 systemText: systext,temperature: 0.6
        )
        let jsonData = response.data(using: .utf8)!
        let decoder = JSONDecoder()
        let metadata = try decoder.decode(OCRMetaData.self, from: jsonData)
        api.deleteHistoryList()
        return metadata
    } catch {
        print(error.localizedDescription)
    }
    return nil
}
