//
//  LoadableView.swift
//  Multisig
//
//  Created by Andrey Scherbovich on 24.06.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import SwiftUI
import Combine

protocol LoadableViewModel: ObservableObject {
    var isLoading: Bool { get set }
    var isRefreshing: Bool { get set }
    var isRefreshingEnabled: Bool { get set }
    var contentWasLoadedOnce: Bool { get set }
    var errorMessage: String? { get set }
    func reloadData()
    func firstTimeLoad()
}

protocol Loadable: View {
    associatedtype LoadableModel: LoadableViewModel
    var model: LoadableModel { get }
}

struct LoadableView<Content: Loadable>: View {
    var reloadsOnAppOpen = true
    private let content: Content

    @ObservedObject
    private var model: Content.LoadableModel

    init(_ content: Content, reloadsOnAppOpen: Bool = true) {
        self.content = content
        self.model = content.model
        self.reloadsOnAppOpen = reloadsOnAppOpen
    }

    var body: some View {
        ZStack(alignment: .center) {
            if model.isLoading {
                loadingView
            } else if model.isRefreshingEnabled {
                GeometryReader { geometryProxy in
                    RefreshableScrollView(refreshing: self.$model.isRefreshing) {
                        ZStack(alignment: .center) {
                            if self.model.errorMessage != nil && !self.model.contentWasLoadedOnce {
                                self.noDataView
                            } else {
                                self.contentView
                            }
                        }
                        .frame(height: geometryProxy.size.height)
                    }
                }
            } else {
                GeometryReader { geometryProxy in
                    ZStack(alignment: .center) {
                        if self.model.errorMessage != nil && !self.model.contentWasLoadedOnce {
                            self.noDataView
                        } else {
                            self.contentView
                        }
                    }
                    .frame(height: geometryProxy.size.height)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if self.reloadsOnAppOpen {
                self.model.reloadData()
            }
        }
    }

    var loadingView: some View {
        GeometryReader { geometryProxy in
            ScrollView {
                ZStack(alignment: .center) {
                    ActivityIndicator(isAnimating: .constant(true), style: .large)

                }
                .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
            }
        }
    }

    var noDataView: some View {
        VStack {
            HStack {
                Image("ico-server-error")
                Text("Data cannot be loaded").title(.gnoMediumGrey)
            }
            .padding(.top, 135)

            Spacer()
        }
    }

    var contentView: some View {
        self.model.firstTimeLoad()
        return content
    }
}

class BasicLoadableViewModel: LoadableViewModel {
    @Published var isLoading: Bool = false

    @Published var isRefreshing: Bool = false {
        didSet {
            if oldValue == false && isRefreshing == true {
                self.reloadData()
            }
        }
    }

    @Published var isRefreshingEnabled: Bool = true

    @Published var errorMessage: String? = nil

    var contentWasLoadedOnce: Bool = false

    var subscribers = Set<AnyCancellable>()

    final func firstTimeLoad() {
        if contentWasLoadedOnce { return }
        contentWasLoadedOnce = true
        reloadData()
    }

    final func reloadData() {
        subscribers.forEach { $0.cancel() }
        isLoading = !isRefreshing
        reload()
    }

    func reload() {
        preconditionFailure("Should be overriden")
    }
}
