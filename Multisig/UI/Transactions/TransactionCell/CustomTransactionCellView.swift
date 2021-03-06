//
//  CustomTransactionCellView.swift
//  Multisig
//
//  Created by Moaaz on 6/4/20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import SwiftUI

struct CustomTransactionCellView: View {
    let transaction: CustomTransactionViewModel
    var body: some View {
        HStack {
            Image("ico-custom-tx")
            AddressCell(address: transaction.to, style: .shortAddressNoShare)

            Spacer()

            VStack {
                Text(transaction.formattedAmount)
                    .body()

                if transaction.dataLength != 0 {
                    Text("\(String(transaction.dataLength)) bytes")
                        .footnote()
                }
            }
        }
    }
}

struct CustomTransactionCellView_Previews: PreviewProvider {
    static var previews: some View {
        let transaction = CustomTransactionViewModel()
        transaction.to = "0x71592E6Cbe7779D480C1D029e70904041F8f602A"
        transaction.confirmationCount = 1
        transaction.threshold = 2
        transaction.formattedDate = "Apr 25, 2020 — 1:01:42PM"
        transaction.nonce = "2"
        transaction.amount = "5"
        transaction.tokenSymbol = " ETH"
        transaction.dataLength = 40
        transaction.status = .success
        return CustomTransactionCellView(transaction: transaction)
    }
}
