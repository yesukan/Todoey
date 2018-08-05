//
//  AppDelegate.swift
//  Todoey
//
//  Created by Yesukan Kozok on 2.08.2018.
//  Copyright © 2018 yesukan. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
       
        
        do {
            _ = try Realm()
//            try realm.write {
//                realm.add(data)
//            }
        } catch {
            print("Error initializing new realm \(error)")
        }
        
        
        
        return true
    }


    
}
