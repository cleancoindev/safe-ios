//
//  KeyValueRow.swift
//  Multisig
//
//  Created by Dmitry Bespalov on 15.05.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import SwiftUI

struct KeyValueRow: View {

    var key: String
    var value: String
    var enableCopy: Bool
    var color: Color
    init(_ key: String, value: String, enableCopy: Bool = true, color: Color = Color.gnoMediumGrey) {
        self.key = key
        self.value = value
        self.enableCopy = enableCopy
        self.color = color
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(key).headline()
            CopyButton(value) {
                Text(value).body(color)
            }.disabled(!enableCopy)
        }
    }
}

struct KeyValueRow_Previews: PreviewProvider {
    static var previews: some View {
        KeyValueRow("Key", value: "Value")
    }
}
