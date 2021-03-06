//
//  SafeClientGatewayServiceIntegrationTests.swift
//  MultisigIntegrationTests
//
//  Created by Dmitry Bespalov on 13.08.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import XCTest
@testable import Multisig

class SafeClientGatewayServiceIntegrationTests: XCTestCase {
    var service = SafeClientGatewayService(url: App.configuration.services.clientGatewayURL, logger: MockLogger())

    func testTransactionsPageLoad() {
        let safes: [Address] = [
            "0x8E77c8D47372Be160b3DC613436927FCc34E1ec0",
            "0x3E742f4CcD32b3CD396218C25A321F38BD51597c",
            "0xba552E35816337Ffb52d8CEC20a151AaFD1e9a24",
            "0x6c45e1E08d14fFE6919c1275006F0eCB0F3e5e39",
            "0x7AA1B0B213493B7a3505f9AfF1BA615Dc576A63D",
            "0x840018fFfbdC9f2Ee8DA5D647f66afDAAebde080",
            "0x360C8AbfdBC4a43568E9a1F39179d86d15aC4FCA",
            "0x5c86B4841caAd0e8e8Ed9F9A837670f7676e7ec7",
            "0xD273610823dFf00Aebbefd1102F3C452d16Ee419",
            "0x3b1c2b0940C85458197E0D18690805d6F89547eE",
            "0x976DC99c50B916Ea9b5275979059BCe9f1A0B1D1",
            "0xD5D4763AE65aFfFD82e3aEe3ec9f21171A1d6e0e",
            "0x360C8AbfdBC4a43568E9a1F39179d86d15aC4FCA",
            "0x2F4A6d752c8F433c5BbCde73FAc97Aa4bdE787AB",
            "0xCF5486D8C09D49A7396311950D1761c5fEF22551",
            "0x5d2F66B7b591198cA36450EFB56823EE26967144",
            "0xb19BDaFf408bB502Ae348aF731C3812670667224",
            "0x1230B3d59858296A31053C1b8562Ecf89A2f888b",
        ]
        continueAfterFailure = false
        for safe in safes {
            goThroughAllTransactions(safe: safe)
        }
    }

    func goThroughAllTransactions(safe: Address, line: UInt = #line) {
        var receivedError: Error?
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            do {
                var page = try self.service.transactionSummaryList(address: safe)
                var pages: [TransactionSummaryListRequest.ResponseType] = [page]
                while let nextPageUri = page.next {
                    page = try self.service.transactionSummaryList(pageUri: nextPageUri)
                    pages.append(page)
                }
            } catch {
                receivedError = error
            }
            semaphore.signal()
        }
        semaphore.wait()
        XCTAssertNil(receivedError, "Safe \(safe.checksummed): \(String(describing: receivedError))", line: line)
    }

    func testTransactionDetails() {
        let safeTxHash = "0xa2a1079e3856e0ef817a8a5279fc967b9a7a4ddecd8e6bb654c0551a0b0b56f4"
        let safeTx = fetchTransaction(safeTxHash: safeTxHash)
        switch safeTx {
        case .success(let tx):
            if let info = tx.detailedExecutionInfo as? MultisigExecutionDetails {
                XCTAssertEqual(info.safeTxHash.data, Data(hex: safeTxHash))
            } else {
                XCTFail("Unexpected tx: \(tx)")
            }
            break
        case .failure(let error):
            XCTFail("Unexpected error: \(error)")
        }

        // currently unsupported by the server
        let ethTxHash = "0x48e31efdd79cd6689f0e42c3aa02993a2f6906662671a72e646dc28c8935422a"
        let ethTx = fetchTransaction(safeTxHash: ethTxHash)
        switch ethTx {
        case .success(let tx):
            if let info = tx.detailedExecutionInfo as? MultisigExecutionDetails {
                XCTAssertEqual(info.safeTxHash.data, Data(hex: safeTxHash))
            } else {
                XCTFail("Unexpected tx: \(tx)")
            }
        case .failure(let error):
            XCTFail("Existing transaction not found: \(error)")
        }

        let invalidHash = "0x0000000000000000000042c3aa02993a2f6906662671a72e646dc28c8935422a"
        let invalidTx = fetchTransaction(safeTxHash: invalidHash)
        switch invalidTx {
        case .success(let tx):
            XCTFail("Unexpected transaction: \(tx)")
        case .failure(let error):
            guard error is HTTPClientError.EntityNotFound else {
                XCTFail("Expected 'not found' error, got this: \(error)")
                return
            }            
        }


        let id = "multisig_0xc05ee463c932c3de977274edb5d2e603b0d431b787bf8ca60a2c22b79c395467"
        let idTx = fetchTransaction(id: id)
        switch idTx {
        case .success(let tx):
            if let info = tx.txInfo as? CustomTransactionInfo {
                XCTAssertEqual(info.dataSize.value, 36)
            } else {
                XCTFail("Unexpected tx: \(tx)")
            }
            break
        case .failure(let error):
            XCTFail("Unexpected error: \(error)")
        }
    }

    func fetchTransaction(safeTxHash: String) -> Result<TransactionDetails, Error> {
        let hash = Data(hex: safeTxHash)
        var result: Result<TransactionDetails, Error>?
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            do {
                let tx = try self.service.transactionDetails(safeTxHash: hash)
                result = .success(tx)
            } catch {
                result = .failure(error)
            }
            semaphore.signal()
        }
        semaphore.wait()

        return result!
    }

    func fetchTransaction(id: String) -> Result<TransactionDetails, Error> {
        let txID = TransactionID(value: id)
        var result: Result<TransactionDetails, Error>?
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            do {
                let tx = try self.service.transactionDetails(id: txID)
                result = .success(tx)
            } catch {
                result = .failure(error)
            }
            semaphore.signal()
        }
        semaphore.wait()

        return result!
    }

}
