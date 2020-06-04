//
//  EnterSafeAddressView.swift
//  Multisig
//
//  Created by Dmitry Bespalov on 24.04.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import SwiftUI

struct EnterSafeAddressView: View {

    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>

    @ObservedObject
    var model: EnterSafeAddressViewModel = EnterSafeAddressViewModel()

    var onSubmit: () -> Void = {}

    var body: some View {
        VStack(spacing: 23) {
            BoldText("Enter your Safe Multisig address.")

            SafeAddressField(title: "Enter Safe address",
                             enteredText: $model.text,
                             displayText: model.displayText,
                             isAddress: $model.isAddress,
                             isValid: $model.isValid,
                             isValidating: $model.isValidating,
                             error: $model.errorMessage)

            Spacer()
        }
        .padding(.top, 27)
        .padding([.leading, .trailing])
        .navigationBarTitle("Load Safe Multisig", displayMode: .inline)
        .navigationBarItems(trailing: nextButton)
        .onReceive(model.$text, perform: model.validate(address:))
    }

    var nextButton: some View {
        NavigationLink("Next", destination:
            EnterSafeNameView(address: $model.displayText.wrappedValue) {
                // dismissing the EnterSafeNameView via its
                // presentation mode will actually pop it back.
                // What we need is to dismiss the whole navigation view,
                // this is controlled by the current view's
                // presentationMode.
                App.shared.viewState.state = .balances
                self.onSubmit()
            }
        )
        // otherwise the "pop to root" stops working
        .isDetailLink(false)
        .barButton(disabled: model.isValid != true)
    }
}

struct AddressForm_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EnterSafeAddressView()
        }
    }
}
