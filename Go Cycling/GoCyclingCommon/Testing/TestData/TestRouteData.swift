//
//  TestRouteData.swift
//  Go Cycling
//
//  Deterministic test route data for UI testing.
//  Each route is a struct conforming to TestRoute protocol.
//  Add new routes by creating additional static properties on TestRoutes.
//

import Foundation
import CoreLocation

struct TestBikeRoute {
    let latitudes: [CLLocationDegrees]
    let longitudes: [CLLocationDegrees]
    let speeds: [CLLocationSpeed]
    let elevations: [CLLocationDistance]
    let distance: Double
    let time: Double
    let startTime: Date
    let routeName: String
}

// MARK: - Test Routes

enum TestRoutes {

    /// All routes to preload. Add new routes here.
    static let all: [TestBikeRoute] = [cupertino, gdansk, recentRide]

    // MARK: - Route 1: Short loop in Cupertino (historical)

    static let cupertino = TestBikeRoute(
        latitudes: [
            37.33170, 37.33250, 37.33340, 37.33430, 37.33520,
            37.33610, 37.33700, 37.33780, 37.33850, 37.33920,
            37.33990, 37.34050, 37.34110, 37.34170, 37.34230
        ],
        longitudes: [
            -122.03020, -122.03100, -122.03180, -122.03250, -122.03320,
            -122.03380, -122.03430, -122.03490, -122.03550, -122.03610,
            -122.03670, -122.03720, -122.03780, -122.03830, -122.03880
        ],
        speeds: [
            5.2, 6.1, 5.8, 6.3, 5.9, 6.0, 5.5, 6.2, 5.7, 6.1,
            5.4, 6.0, 5.9, 5.6, 6.3
        ],
        elevations: [
            20.0, 21.5, 23.0, 22.5, 24.0, 25.5, 26.0, 24.5, 23.0, 22.0,
            21.0, 20.5, 22.0, 23.5, 24.0
        ],
        distance: 1250.0,
        time: 210.0,
        startTime: Date(timeIntervalSince1970: 1704067200), // 2024-01-01 10:00:00 UTC
        routeName: "Cupertino Ride"
    )

    static let gdansk = TestBikeRoute(
        latitudes: [
            54.39450, 54.39520, 54.39610, 54.39700, 54.39780,
            54.39870, 54.39950, 54.40050, 54.40140, 54.40230,
            54.40320, 54.40410, 54.40500, 54.40580, 54.40660,
            54.40740, 54.40820, 54.40900, 54.40970, 54.41050
        ],
        longitudes: [
            18.57200, 18.57120, 18.57040, 18.56950, 18.56870,
            18.56780, 18.56700, 18.56610, 18.56530, 18.56440,
            18.56360, 18.56270, 18.56180, 18.56100, 18.56010,
            18.55930, 18.55840, 18.55760, 18.55670, 18.55590
        ],
        speeds: [
            5.8, 6.2, 6.5, 6.1, 5.9, 6.3, 6.7, 6.4, 6.0, 5.7,
            6.2, 6.5, 6.8, 6.3, 5.9, 6.1, 6.4, 6.6, 6.2, 5.8
        ],
        elevations: [
            12.0, 13.5, 15.0, 16.5, 18.0, 19.5, 21.0, 22.5, 24.0, 25.5,
            27.0, 28.5, 30.0, 31.5, 33.0, 34.5, 36.0, 37.5, 39.0, 40.0
        ],
        distance: 3200.0,
        time: 510.0,
        startTime: Date(timeIntervalSince1970: 1704110400), // 2024-01-01 22:00:00 UTC
        routeName: "Gdansk Ride"
    )

    // MARK: - Route 3: Recent ride (yesterday) — ensures charts have data for "Past 7 Days"

    static let recentRide = TestBikeRoute(
        latitudes: [
            54.37200, 54.37280, 54.37360, 54.37440, 54.37520,
            54.37600, 54.37680, 54.37760, 54.37840, 54.37920
        ],
        longitudes: [
            18.62000, 18.62080, 18.62160, 18.62240, 18.62320,
            18.62400, 18.62480, 18.62560, 18.62640, 18.62720
        ],
        speeds: [
            6.0, 6.3, 6.1, 6.5, 6.2, 6.4, 6.0, 6.6, 6.3, 6.1
        ],
        elevations: [
            8.0, 8.5, 9.0, 9.5, 10.0, 10.5, 11.0, 10.5, 10.0, 9.5
        ],
        distance: 1500.0,
        time: 240.0,
        startTime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, // yesterday
        routeName: "Recent Ride"
    )
}
