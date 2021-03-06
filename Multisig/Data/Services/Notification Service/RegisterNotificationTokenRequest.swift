//
//  RegisterNotificationTokenRequest.swift
//  Multisig
//
//  Created by Moaaz on 8/5/20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import Foundation
import Web3

struct RegisterNotificationTokenRequest: JSONRequest {
    let uuid: String
    let safes: [String]
    let cloudMessagingToken: String
    let bundle: String
    let version: String
    let deviceType: String = "IOS"
    let buildNumber: String
    let timestamp: String?
    let signatures: [String]?

    var httpMethod: String { return "POST" }
    var urlPath: String { return "/api/v1/notifications/devices/" }

    typealias ResponseType = Response

    init(deviceID: String,
         safes: [Address],
         token: String,
         bundle: String,
         version: String,
         buildNumber: String,
         timestamp: String?) throws {

        guard UUID(uuidString: deviceID) != nil else {
            preconditionFailure("'deviceID' should be UUID string")
        }
        self.uuid = deviceID.lowercased()
        self.safes = safes.map { $0.checksummed }
        self.cloudMessagingToken = token
        self.bundle = bundle
        self.version = version
        self.buildNumber = buildNumber
        self.timestamp = timestamp

        let string = [
            "gnosis-safe",
            self.timestamp ?? "",
            self.uuid,
            self.cloudMessagingToken,
            self.safes.sorted().joined()
        ]
        .joined()

        if let signature = try? Signer.sign(string).value {
            guard timestamp != nil else {
                preconditionFailure("'timestamp' parameter is required if signing key exists")
            }
            self.signatures = [signature]
        } else {
            self.signatures = nil
        }
    }

    struct Response: Decodable {
        let uuid: UUID
        let safes: [String]
        let cloudMessagingToken: String
        let bundle: String
        let version: String
        let deviceType: String
        let buildNumber: Int
    }
}

extension SafeTransactionService {

    @discardableResult
    func register(deviceID: String,
                  safes: [Address],
                  token: String,
                  bundle: String,
                  version: String,
                  buildNumber: String,
                  timestamp: String?) throws -> RegisterNotificationTokenRequest.Response {
        return try execute(
            request: try RegisterNotificationTokenRequest(deviceID: deviceID,
                                                          safes: safes,
                                                          token: token,
                                                          bundle: bundle,
                                                          version: version,
                                                          buildNumber: buildNumber,
                                                          timestamp: timestamp)
        )
    }
}
