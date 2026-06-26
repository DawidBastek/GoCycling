//
//  Timeouts.swift
//  Go CyclingUITests
//
//  Centralized timeout values for UI test element waits.
//

import Foundation

enum Timeouts {
    /// Default timeout for waitForExistence across all Pages.
    static let waitForExistence: TimeInterval = 3

    /// Timeout for map tile rendering before snapshots.
    static let mapRender: TimeInterval = 5
}
