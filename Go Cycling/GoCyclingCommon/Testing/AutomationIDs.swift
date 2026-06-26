//
//  AutomationIDs.swift
//  Go Cycling
//

enum AutomationIDs {
    enum Cycle {
        static let metricsSpeed = "cycle.metricsSpeed"
        static let metricsDistance = "cycle.metricsDistance"
        static let metricsAltitude = "cycle.metricsAltitude"
        static let mapView = "cycle.map"
        static let startButton = "cycle.start"
        static let pauseButton = "cycle.pause"
        static let resumeButton = "cycle.resume"
        static let stopButton = "cycle.stop"
        
        // Route name modal
        static let categoryNameTextField = "cycle.categoryNameTextField"
        static let saveRouteNameButton = "cycle.saveRouteNameButton"
        static let saveRouteWithoutCategoryButton = "cycle.saveRouteWithoutCategoryButton"
    }
    
    enum History {
        static let emptyStateLabel = "history.emptyState"
        static let routeDetailsMapView = "history.routeDetailsMapView"
        
        static func routeCell(at index: Int) -> String {
            return "history.cell.\(index)"
        }
    }
    
    enum Statistics {
        static let chartPast7Days = "statistics.chartPast7Days"
        static let chartPast5Weeks = "statistics.chartPast5Weeks"
        static let chartPast30Weeks = "statistics.chartPast30Weeks"
    }
    
    enum Settings {
        static let imperialSegment = "settings.imperialSegment"
        static let metricSegment = "settings.metricSegment"
        static let deleteAllStoredRoutesButton = "settings.deleteAllStoredRoutesButton"
    }
}
