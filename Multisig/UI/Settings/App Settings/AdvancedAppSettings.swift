//
//  AdvancedAppSettings.swift
//  Multisig
//
//  Created by Dmitry Bespalov on 15.05.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import SwiftUI

struct AdvancedAppSettings: View {

    @ObservedObject
    var theme: Theme = App.shared.theme

    var body: some View {
        List {
            Section(header: SectionHeader("ENS RESOLVER ADDRESS")) {
                AddressCell(address: App.shared.ens.registryAddress.checksummed)
            }

            Section(header: SectionHeader("ENDPOINTS")) {
                KeyValueRow("RPC endpoint",
                            value: DisplayURL(App.shared.nodeService.url).absoluteString)
                KeyValueRow("Transaction service",
                            value: DisplayURL(App.shared.safeTransactionService.url).absoluteString)
                KeyValueRow("Client Gateway service",
                            value: DisplayURL(App.shared.clientGatewayService.url).absoluteString)
            }

            if !(App.configuration.services.environment == .production) {
                Section(header: SectionHeader("DEBUG")) {
                    Button(action: {
                        fatalError()
                    }) {
                        Text("Crash the App").body()
                    }
                }
            }
        }
        .onAppear {
            self.trackEvent(.settingsAppAdvanced)
        }
        .navigationBarTitle("Advanced", displayMode: .inline)
    }
}

struct AdvancedAppSettings_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedAppSettings()
    }
}
