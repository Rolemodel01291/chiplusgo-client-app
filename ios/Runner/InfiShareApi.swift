//
//  InfiShareApi.swift
//  Runner
//
//  Created by Chaoxiang Wen on 8/3/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class InfiShareApi {
    static let sharedInstance = InfiShareApi()
    
    let apiPrefix = "https://us-central1-chiplusgo-95ec4.cloudfunctions.net/"
    let stripeChargeCustomerUrl = "chargeCust/"
    let stripeChargeBalanceUrl = "paymentIntentV2/recharge/"
    let createPaymentIntent = "paymentIntentV2/chargeCust/"
    
    func createPaymentIntent(token: String, businessId: String, couponId: String, amount: Int, count: Int, reward: Int, tips: Double, tax: Double, balance: Double=0.0,completion:@escaping (String?,Error?)-> Void) {
        AF.request(self.apiPrefix + self.createPaymentIntent, method: .post, parameters: [
            "Amount": amount,
            "CouponId": couponId,
            "Count": count,
            "Tips":tips,
            "Tax":tax,
            "Payer":["Balance":balance],
            "Reward":reward,
            "BusinessId": businessId], headers: ["Authorization": "Bearer \(token)"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    do {
                        let json = try JSON(data: response.data!)
                        completion(json["Client_secret"].string,nil)
                    } catch {
                        completion(nil, error)
                    }
                case .failure(let error):
                    do {
                        let json = try JSON(data: response.data!)
                        completion(nil,NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey:json["message"].string ?? "Check out failed, Please try again"]))
                    } catch {
                        completion(nil, error)
                    }
                }
        }
    }
    
    func chargeWith(token: String, businessId: String ,stripeToken: String, couponId: String, amount: Int, count: Int, reward: Int, tips: Double, tax: Double, balance: Double=0.0,completion:@escaping (String?,Error?)-> Void) {
                AF.request(self.apiPrefix + self.stripeChargeCustomerUrl, method: .post, parameters: [
                    "SourceId": stripeToken,
                    "Amount": amount,
                    "CouponId": couponId,
                    "Count": count,
                    "Tips":tips,
                    "Tax":tax,
                    "Payer":["Balance":balance],
                    "Reward":reward,
                    "BusinessId": businessId], headers: ["Authorization": "Bearer \(token)"])
                    .validate(statusCode: 200..<300)
                    .responseJSON { response in
                        switch response.result {
                        case .success(_):
                            do {
                                let json = try JSON(data: response.data!)
                                completion(json["receipt_number"].string,nil)
                            } catch {
                                completion(nil, error)
                            }
                        case .failure(let error):
                            do {
                                let json = try JSON(data: response.data!)
                                completion(nil,NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey:json["message"].string ?? "Check out failed, Please try again"]))
                            } catch {
                                completion(nil, error)
                            }
                        }
                }
        }
    
    func chargeBalanceWith(token: String, amount: Int,completion:@escaping (String?,Error?)-> Void) {
                    AF.request(self.apiPrefix + self.stripeChargeBalanceUrl,
                                      method: .post,
                                      parameters: ["Amount":amount],
                                      headers: ["Authorization": "Bearer \(token)"]).validate(statusCode: 200..<300).responseString(completionHandler: { (response) in
                                        switch response.result {
                                        case .success(_):
                                            do {
                                                let json = try JSON(data: response.data!)
                                                completion(json["Client_secret"].string,nil)
                                            } catch {
                                                completion(nil, error)
                                            }
                                        case .failure(let error):
                                            do {
                                                let json = try JSON(data: response.data!)
                                                completion(nil,NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey:json["message"].string ?? "Charge failed, Please try again"]))
                                            } catch {
                                                completion(nil,error)
                                            }
                                        }
                                      })
    }
}
