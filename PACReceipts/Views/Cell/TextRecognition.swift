//
//  TextRecognition.swift
//  PACReceipts
//
//  Created by kent daniel on 10/9/2023.
//

import Vision
import UIKit

func detectText(in image: UIImage, completion: @escaping (String?) -> Void) {
    var textResult: String = ""
    
    guard let image = image.cgImage else {
        print("Invalid image")
        completion(nil)
        return
    }
    
    let request = VNRecognizeTextRequest { request, error in
        if let error = error {
            print("Error detecting text: \(error)")
            completion(nil)
        } else {
            textResult = handleDetectionResults(results: request.results)
            completion(textResult)
        }
    }
    
    request.recognitionLanguages = ["en_US"]
    request.recognitionLevel = .accurate
    
    performDetection(request: request, image: image)
}


private func performDetection(request: VNRecognizeTextRequest, image: CGImage) {
    let requests = [request]
    
    let handler = VNImageRequestHandler(cgImage: image, orientation: .up, options: [:])
    
    DispatchQueue.global(qos: .userInitiated).async {
        do {
            try handler.perform(requests)
        } catch let error {
            print("Error: \(error)")
        }
    }
}


private func handleDetectionResults(results: [Any]?) -> String {
    var textOCRResults: String = ""
    guard let results = results, results.count > 0 else {
        print("No text found")
        return textOCRResults
    }
    
    for result in results {
        if let observation = result as? VNRecognizedTextObservation {
            for text in observation.topCandidates(1) {
                textOCRResults+=text.string
            }
        }
        
    }
    return textOCRResults
    
}
