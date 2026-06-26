//
//  TestDataManager.swift
//  Go Cycling
//
//  Manages test data injection for UI testing.
//  Called from GoCyclingApp when `-UITesting` launch arguments are present.
//

import Foundation
import CoreData
import CoreLocation

enum TestDataManager {

    /// Handles all test data setup based on launch arguments.
    static func handleLaunchArguments(context: NSManagedObjectContext) {
        guard CommandLine.arguments.contains(LaunchArguments.uiTesting) else { return }

        if CommandLine.arguments.contains(LaunchArguments.preloadTestRoute) {
            preloadTestRoute(context: context)
        }
        if CommandLine.arguments.contains(LaunchArguments.clearAllData) {
            clearAllData(context: context)
        }
    }

    // MARK: - Preload Test Route

    /// Preloads all deterministic bike rides defined in TestRoutes
    /// and sets corresponding statistics in UserDefaults.
    private static func preloadTestRoute(context: NSManagedObjectContext) {
        for route in TestRoutes.all {
            let fetchRequest: NSFetchRequest<BikeRide> = BikeRide.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "cyclingRouteName == %@", route.routeName)
            let existingCount = (try? context.count(for: fetchRequest)) ?? 0
            guard existingCount == 0 else { continue }

            let ride = BikeRide(context: context)
            ride.cyclingLatitudes = route.latitudes
            ride.cyclingLongitudes = route.longitudes
            ride.cyclingSpeeds = route.speeds
            ride.cyclingElevations = route.elevations
            ride.cyclingDistance = route.distance
            ride.cyclingTime = route.time
            ride.cyclingStartTime = route.startTime
            ride.cyclingRouteName = route.routeName
        }

        try? context.save()

        // Preload statistics records into UserDefaults
        preloadRecords()
    }

    /// Computes and stores cycling records in UserDefaults based on TestRoutes data.
    /// This ensures the Statistics tab shows correct values without needing
    /// the app to process routes at runtime.
    private static func preloadRecords() {
        let routes = TestRoutes.all

        let totalDistance = routes.reduce(0.0) { $0 + $1.distance }
        let totalTime = routes.reduce(0.0) { $0 + $1.time }
        let totalRoutes = routes.count

        let longestDistance = routes.max(by: { $0.distance < $1.distance })!
        let longestTime = routes.max(by: { $0.time < $1.time })!

        // Best average speed (only routes > 1 km)
        var bestAvgSpeed: Double = 0.0
        var bestAvgSpeedDate: Date?
        for route in routes where route.distance > 999 {
            let avgSpeed = route.distance / route.time
            if avgSpeed > bestAvgSpeed {
                bestAvgSpeed = avgSpeed
                bestAvgSpeedDate = route.startTime
            }
        }

        UserDefaults.standard.set(totalTime, forKey: "totalCyclingTime")
        UserDefaults.standard.set(totalDistance, forKey: "totalCyclingDistance")
        UserDefaults.standard.set(longestDistance.distance, forKey: "longestCyclingDistance")
        UserDefaults.standard.set(longestTime.time, forKey: "longestCyclingTime")
        UserDefaults.standard.set(bestAvgSpeed, forKey: "fastestAverageSpeed")
        UserDefaults.standard.set(totalRoutes, forKey: "totalCyclingRoutes")
        UserDefaults.standard.set(longestDistance.startTime, forKey: "longestCyclingDistanceDate")
        UserDefaults.standard.set(longestTime.startTime, forKey: "longestCyclingTimeDate")
        if let date = bestAvgSpeedDate {
            UserDefaults.standard.set(date, forKey: "fastestAverageSpeedDate")
        }
        UserDefaults.standard.set([Bool](repeating: false, count: 6), forKey: "unlockedIcons")
        UserDefaults.standard.set(true, forKey: "didSetupRecords")
    }

    // MARK: - Clear All Data

    /// Deletes all bike rides from Core Data and resets statistics in UserDefaults.
    private static func clearAllData(context: NSManagedObjectContext) {
        // Clear Core Data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BikeRide")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
            context.reset()
        } catch {
            print("Failed to clear test data: \(error.localizedDescription)")
        }

        // Reset statistics in UserDefaults
        UserDefaults.standard.set(0.0, forKey: "totalCyclingTime")
        UserDefaults.standard.set(0.0, forKey: "totalCyclingDistance")
        UserDefaults.standard.set(0.0, forKey: "longestCyclingDistance")
        UserDefaults.standard.set(0.0, forKey: "longestCyclingTime")
        UserDefaults.standard.set(0.0, forKey: "fastestAverageSpeed")
        UserDefaults.standard.set(0, forKey: "totalCyclingRoutes")
        UserDefaults.standard.removeObject(forKey: "longestCyclingDistanceDate")
        UserDefaults.standard.removeObject(forKey: "longestCyclingTimeDate")
        UserDefaults.standard.removeObject(forKey: "fastestAverageSpeedDate")
    }
}
