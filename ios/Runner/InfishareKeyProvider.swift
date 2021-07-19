//
//  InfishareKeyProvider.swift
//  Runner
//
//  Created by Chaoxiang Wen on 8/3/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
import SwiftyJSON

class InfishareKeyProvider: NSObject, STPCustomerEphemeralKeyProvider {
    
    let apiPrefix = "https://us-central1-chiplusgo-95ec4.cloudfunctions.net/"
    let stripeEphemeralKeysUrl = "ephemeralKeys/"
    var token: String
    
    init(token: String) {
        self.token = token
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        AF.request(self.apiPrefix + self.stripeEphemeralKeysUrl, method: .post, parameters: [
            "api_version": apiVersion
            ], headers: ["Authorization": "Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                print(responseJSON)
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    do {
                        let json = try JSON(data: responseJSON.data!)
                        completion(nil,NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey:json["message"].string ?? "Get payment info failed, Please try again"]))
                    } catch {
                        completion(nil, error)
                    }
                }
        }
    }
}
