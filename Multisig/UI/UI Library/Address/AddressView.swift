//
//  AddressView.swift
//  Multisig
//
//  Created by Dmitry Bespalov on 17.04.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import SwiftUI

struct AddressView: View {

    private var text: String

    init(_ text: String) {
        self.text = text
    }

    init(_ address: Address) {
        self.text = address.checksummed
    }

    var body: some View {
        HStack {
            if !text.isEmpty {
                AddressImage(text).frame(width: 32, height: 32)
            }

            SlicedText(Address(exactly: text))
                .style(.addressLong)
                .font(nil)
        }
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView("0xcd2a3d9f938e13cd947ec05abc7fe734df8dd826")
            .frame(width: 270)
    }
}
