//
//  CreationTransactionSummaryViewModel.swift
//  Multisig
//
//  Created by Moaaz on 9/2/20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import UIKit

class CreationTransactionViewModel: TransactionViewModel {
    var creator: String?
    var implementationUsed: String?
    var contractVersion: String?
    var factoryUsed: String?

    override func bind(info: TransactionInfo) {
        let creattionTransactionInfo = info as! CreationTransactionInfo
        creator = creattionTransactionInfo.creator.address.checksummed
        implementationUsed = creattionTransactionInfo.implementation?.address.checksummed
        if let implementationUsed = implementationUsed {
            contractVersion = GnosisSafe().versionNumber(implementation: Address(exactly: implementationUsed)) ?? "Unknown"
        }

        factoryUsed = creattionTransactionInfo.factory?.address.checksummed
        hash = creattionTransactionInfo.transactionHash.description
    }

    class func isValid(info: TransactionInfo) -> Bool {
        info is CreationTransactionInfo
    }

    override class func viewModels(from tx: SCGTransaction) -> [TransactionViewModel] {
        isValid(info: tx.txInfo) ? [CreationTransactionViewModel(tx)] : []
    }
}
