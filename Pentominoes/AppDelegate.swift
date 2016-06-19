//
//  AppDelegate.swift
//  Pentominoes
//
//  Created by Richard Turton on 19/06/2016.
//  Copyright © 2016 Richard Turton. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        if let vc = window?.rootViewController as? PentominoesViewController {
            let board = Board(size: .SixByTen)
            let tiles = (0..<12).map { Tile(shape: Shape(rawValue: $0)!) }
            vc.board = board
            vc.tiles = tiles
        }
        return true
    }


}

