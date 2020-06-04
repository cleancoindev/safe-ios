//
//  ENSNameLoader.swift
//  Multisig
//
//  Created by Dmitry Bespalov on 06.05.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import Foundation
import Combine

class ENSNameLoader: ObservableObject {

    private var subscribers = Set<AnyCancellable>()

    @Published
    var isLoading: Bool = true

    init(safe: Safe) {
        Just(safe.address)
            .compactMap { $0 }
            .compactMap { Address($0) }
            .flatMap { address in
                Future<String?, Never> { promise in
                    DispatchQueue.global().async {
                        let ensName = try? App.shared.ens.name(for: address)
                        promise(.success(ensName))
                    }
                }
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
            }, receiveValue: { ensName in
                if safe.ensName != ensName {
                    // updating safe triggers update cycles of the whole view hierarchy
                    // and ends up in an infinite loop
                    safe.ensName = ensName
                }
            })
            .store(in: &subscribers)
    }
}
