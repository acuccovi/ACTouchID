//
//  ACTouchID.swift
//  ACTouchID
//
//  Created by Alessio Cuccovillo on 14/11/16.
//  Copyright © 2016 Alessio Cuccovillo. All rights reserved.
//

import Foundation
import LocalAuthentication
import UIKit

public protocol ACTouchIDDelegate {
    func ACTouchIDAuthDone(withResult success: Bool, andError error: (code: Int, description: String)?)
}

public class ACTouchID: NSObject {
    public var delegate: ACTouchIDDelegate?
    public var errorMessages: [LAError.Code : String]
    public var defaultErrorMessage: String

    private var reason = ""
    private let laContext = LAContext()
    private var viewController: UIViewController?

    public init(_ reason: String) {
        self.errorMessages = [
            LAError.Code.systemCancel : "Authentication cancelled by the system",
            LAError.Code.userCancel : "Authentication cancelled by the user",
            LAError.Code.userFallback : "User wants to use a password",
            LAError.Code.touchIDNotEnrolled : "TouchID not enrolled",
            LAError.Code.passcodeNotSet : "Passcode not set"
        ]
        self.defaultErrorMessage = "Authentication failed"
        super.init()
        self.reason = reason

    }

    public func requireTouchIDAtuth() {
        var laError: NSError?
        laContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &laError)
        if let e = laError {
            callTouchIdDelegate(withResult: false, andError: (code: e.code, description: e.description))
        } else {
            laContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (sucess: Bool!, error: Error?) -> Void in
                if let err = error {
                    let errorCode = (err as NSError).code
                    var errorMessage: String
                    switch errorCode {
                    case LAError.Code.systemCancel.rawValue:
                        errorMessage = self.errorMessages[LAError.Code.systemCancel]!
                    case LAError.Code.userCancel.rawValue:
                        errorMessage = self.errorMessages[LAError.Code.userCancel]!
                    case LAError.Code.userFallback.rawValue:
                        errorMessage = self.errorMessages[LAError.Code.systemCancel]!
                    case LAError.Code.touchIDNotEnrolled.rawValue:
                        errorMessage = self.errorMessages[LAError.Code.touchIDNotEnrolled]!
                    case LAError.Code.passcodeNotSet.rawValue:
                        errorMessage = self.errorMessages[LAError.Code.passcodeNotSet]!
                    default:
                        errorMessage = self.defaultErrorMessage
                    }
                    self.callTouchIdDelegate(withResult: false, andError: (code: errorCode, description: errorMessage))
                } else {
                    self.callTouchIdDelegate(withResult: true, andError: nil)
                }
            })
        }
    }

    private func callTouchIdDelegate(withResult resutl: Bool, andError error: (code: Int, description: String)?) {
        delegate?.ACTouchIDAuthDone(withResult: resutl, andError: error)
    }
}
