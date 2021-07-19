import UIKit
import Flutter
import Stripe
import SwiftyJSON
import GoogleMaps
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    
    private var eventSink: FlutterEventSink?
    var checkoutResult: FlutterResult?
    var stripePaymentContext: STPPaymentContext!
    var paymentMap:[String:Any] = [:]
    var flutterController: FlutterViewController!
    override func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    
//    if #available(iOS 10.0, *) {
//      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
//    }
    
    GMSServices.provideAPIKey("AIzaSyBtlQOHV180B4eEZgtC-ndzBCvjpqQMhMo")
        flutterController = window?.rootViewController as! FlutterViewController
    let stripeChannel = FlutterMethodChannel(name: "com.infishare/stripe_payment", binaryMessenger: flutterController as! FlutterBinaryMessenger)
        stripeChannel.setMethodCallHandler { (call, result) in
            if call.method == "editPayment" {
                self.setupStripe()
                let map = call.arguments as! [String:Any]
                let provider = InfishareKeyProvider(token: map["token"] as! String)
                let customerContext = STPCustomerContext(keyProvider: provider)
                self.stripePaymentContext = STPPaymentContext(customerContext: customerContext)
                self.stripePaymentContext.delegate = self
                self.stripePaymentContext.hostViewController = self.flutterController
                self.stripePaymentContext.presentPaymentOptionsViewController()
                result(["msg":"success"])
            } else if call.method == "showChoosePayment" {
                self.stripePaymentContext.presentPaymentOptionsViewController()
            } else if call.method == "createPaymentToken" {
                self.checkoutResult = result
                let map = call.arguments as! [String:Any]
                self.paymentMap = map
                let amount = map["amount"] as! Int
                if amount == 0 {
                    InfiShareApi.sharedInstance.chargeWith(token: self.paymentMap["token"] as! String, businessId: self.paymentMap["businessId"] as! String, stripeToken: "", couponId: self.paymentMap["couponId"] as! String, amount: self.paymentMap["amount"] as! Int, count: self.paymentMap["count"] as! Int, reward: self.paymentMap["reward"] as! Int, tips: self.paymentMap["tips"] as! Double, tax: self.paymentMap["tax"] as! Double, balance: self.paymentMap["balance"] as! Double) { (receiptNum, error) in
                        if let result = self.checkoutResult {
                            if let error = error {
                                result(["error":error.localizedDescription])
                            }
                    
                            if let num = receiptNum {
                                result(["receipt":num])
                            }
                        }
                    }
                } else {
                    self.stripePaymentContext.paymentAmount = map["amount"] as! Int
                    self.stripePaymentContext.requestPayment()
                }
            } else if call.method == "chargeInfiCash" {
                self.checkoutResult = result
                let map = call.arguments as! [String:Any]
                self.paymentMap = map
                self.stripePaymentContext.paymentAmount = map["amount"] as! Int
                self.stripePaymentContext.requestPayment()
            }
        }
    
    let paymentChannel = FlutterEventChannel(name: "com.infishare/stripe_payment_method", binaryMessenger: flutterController as! FlutterBinaryMessenger)
    paymentChannel.setStreamHandler(self)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func setupStripe() {
        STPPaymentConfiguration.shared.publishableKey = "pk_test_51IhGpXFIj1dtK6GQYgumpbwCzaH5fRBG4aWLDZLbBgu5qK1gHJ4ihRBa0TyaKGrQ5abVX31iXSxdxCRjybg1In9U008kFVC82F"
        print("pk_test_51IhGpXFIj1dtK6GQYgumpbwCzaH5fRBG4aWLDZLbBgu5qK1gHJ4ihRBa0TyaKGrQ5abVX31iXSxdxCRjybg1In9U008kFVC82F")
        STPPaymentConfiguration.shared.appleMerchantIdentifier = "merchant.com.InfishareClient"
        STPPaymentConfiguration.shared.companyName = "Infinet,LLC"
//        STPPaymentConfiguration.shared.additionalPaymentOptions = 3
        //STPTheme.default().primaryBackgroundColor = UIColor.white
    }
}

extension AppDelegate: STPPaymentContextDelegate {


    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        if let _ = paymentMap["businessId"] {
            InfiShareApi.sharedInstance.createPaymentIntent(token: paymentMap["token"] as! String, businessId: paymentMap["businessId"] as! String, couponId: paymentMap["couponId"] as! String, amount: paymentMap["amount"] as! Int, count: paymentMap["count"] as! Int, reward: paymentMap["reward"] as! Int, tips: paymentMap["tips"] as! Double, tax: paymentMap["tax"] as! Double, balance: paymentMap["balance"] as! Double) {(secret,error) in
                if let result = self.checkoutResult {
                    if let error = error {
                        result(["error":error.localizedDescription])
                        completion(.error, error)
                    }
                    
                    if let sec = secret {
                        let paymentIntentParams = STPPaymentIntentParams(clientSecret: sec)
                        paymentIntentParams.paymentMethodId = paymentResult.paymentMethod?.stripeId
                        
                        // Confirm the PaymentIntent
                        STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
                            switch status {
                            case .succeeded:
                                // Your backend asynchronously fulfills the customer's order, e.g. via webhook
                                completion(.success, nil)
                                let index = paymentResult.paymentMethod?.stripeId.index((paymentResult.paymentMethod?.stripeId.endIndex)!, offsetBy: -8)
                                let mySubstring = paymentResult.paymentMethod?.stripeId.suffix(from: index!)
                                result(["receipt":mySubstring])
                            case .failed:
                                completion(.error, error) // Report error
                            case .canceled:
                                completion(.userCancellation, nil) // Customer cancelled
                            @unknown default:
                                completion(.error, nil)
                            }
                        }
                    }
                }
            }
        } else {
            /// buy inficash
            InfiShareApi.sharedInstance.chargeBalanceWith(token: paymentMap["token"] as! String, amount: paymentMap["amount"] as! Int) { (secret,error) in
                if let result = self.checkoutResult {
                    if let error = error {
                        result(["error":error.localizedDescription])
                        completion(.error,error)
                    }
                    
                    if let sec = secret {
                        let paymentIntentParams = STPPaymentIntentParams(clientSecret: sec)
                        paymentIntentParams.paymentMethodId = paymentResult.paymentMethod?.stripeId
                        
                        // Confirm the PaymentIntent
                        STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
                            switch status {
                            case .succeeded:
                                // Your backend asynchronously fulfills the customer's order, e.g. via webhook
                                result(["message":"success"])
                                completion(.success,nil)
                            case .failed:
                                completion(.error, error) // Report error
                            case .canceled:
                                completion(.userCancellation, nil) // Customer cancelled
                            @unknown default:
                                completion(.error, nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        if let event = eventSink {
            event(["error":"Fail to load payment method"])
        }
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if !paymentContext.loading, let event = eventSink {
            if let paymentMethod = paymentContext.selectedPaymentOption {
                event(["method":paymentMethod.label])
            } else {
                event(["method":""])
            }
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        // no need to implement, handle check out logic to flutter
        if let result = self.checkoutResult {
            switch status {
            case .error:
                result(["error":error?.localizedDescription])
                break
            case .success:
                //log user event
                break;
            case .userCancellation:
                result(["Cancel":"Yes"])
                return // Do nothing
            }
        }
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        setupStripe()
        self.eventSink = events
        let map = arguments as! [String:Any]
        let provider = InfishareKeyProvider(token: map["token"] as! String)
        let customerContext = STPCustomerContext(keyProvider: provider)
        self.stripePaymentContext = STPPaymentContext(customerContext: customerContext)
        self.stripePaymentContext.delegate = self
        self.stripePaymentContext.hostViewController = flutterController
        return nil
    }
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
