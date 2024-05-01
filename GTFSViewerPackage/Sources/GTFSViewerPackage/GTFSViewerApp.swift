//
//  GTFSViewerApp.swift
//
//
//  Created by Kanta Oikawa on 2024/04/24.
//

import GTFSRealtimeViewer
import SwiftUI

public struct GTFSViewerApp: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            GTFSRealtimeView()
        }
    }
}
