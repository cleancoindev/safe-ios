//
//  EnterSafeNameViewModel.swift
//  Multisig
//
//  Created by Dmitry Bespalov on 24.04.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import Foundation
import Combine

class EditSafeNameViewModel: ObservableObject {

    @Published
    var enteredText: String = ""

    @Published
    var isValid: Bool?

    @Published
    var error: String = ""

    var validatedText: String {
        enteredText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var address: String

    private var subscribers = Set<AnyCancellable>()

    var name: String

    init(address: String, name: String) {
        self.address = address
        self.name = name
        self.enteredText = name
        $enteredText
            .dropFirst()
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .sink { [weak self] value in
                guard let `self` = self else { return }
                self.isValid = !value.isEmpty
                self.error = self.isValid == false ? GSError.InvalidSafeName().localizedDescription : ""
            }
            .store(in: &subscribers)
    }

    func reset() {
        enteredText = name
        isValid = nil
        error = ""
    }

    func onEditing() {
        self.isValid = validatedText.isEmpty ? nil : true
    }

    func submit() {
        guard isValid == true else { return }
        Safe.edit(address: address, name: validatedText)
    }

}
