//
//  Swipe+Extension.swift
//
//  Extension for swipe
//

import Foundation
import XCTest

extension XCUIElement {
    enum direction: String {
        case up, down, left, right
    }

    private var half: CGFloat { 0.5 }
    private var adjustment: CGFloat { 0.3 }
    private var pressDuration: TimeInterval { 0.05 }

    private var lessThanHalf: CGFloat { half - adjustment }
    private var moreThanHalf: CGFloat { half + adjustment }

    private var centre: XCUICoordinate { self.coordinate(withNormalizedOffset: CGVector(dx: half, dy: half)) }
    private var aboveCentre: XCUICoordinate { self.coordinate(withNormalizedOffset: CGVector(dx: half, dy: lessThanHalf)) }
    private var belowCentre: XCUICoordinate { self.coordinate(withNormalizedOffset: CGVector(dx: half, dy: moreThanHalf)) }
    private var leftOfCentre: XCUICoordinate { self.coordinate(withNormalizedOffset: CGVector(dx: lessThanHalf, dy: half)) }
    private var rightOfCentre: XCUICoordinate { self.coordinate(withNormalizedOffset: CGVector(dx: moreThanHalf, dy: half)) }

    func longSwipe(_ direction: direction) {
        switch direction {
        case .up:
            belowCentre.press(forDuration: pressDuration, thenDragTo: aboveCentre)
        case .down:
            aboveCentre.press(forDuration: pressDuration, thenDragTo: belowCentre)
        case .left:
            rightOfCentre.press(forDuration: pressDuration, thenDragTo: leftOfCentre)
        case .right:
            leftOfCentre.press(forDuration: pressDuration, thenDragTo: rightOfCentre)
        }
    }

    func shortSwipe(_ direction: direction) {
        switch direction {
        case .up:
            centre.press(forDuration: pressDuration, thenDragTo: aboveCentre)
        case .down:
            centre.press(forDuration: pressDuration, thenDragTo: belowCentre)
        case .left:
            centre.press(forDuration: pressDuration, thenDragTo: leftOfCentre)
        case .right:
            centre.press(forDuration: pressDuration, thenDragTo: rightOfCentre)
        }
    }
}
