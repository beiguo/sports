//
//  HealthManager.swift
//  myHealth
//
//  Created by shilei on 2017/9/12.
//  Copyright © 2017年 石庆磊. All rights reserved.
//

import Foundation
import HealthKit
import HealthKitUI

class HealthManager: NSObject {
    
    
    let healthKitStore:HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: ((_ success:Bool, _ error:NSError?) -> Void)!){
    
        let healthKitTypesToRead = NSSet(array: [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
//            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
//            HKObjectType.workoutType()
            ])
        
        if !HKHealthStore.isHealthDataAvailable() {
            let error = NSError(domain: "com.raywenderlich.tutorials.healthkit", code: 2, userInfo: [NSLocalizedDescriptionKey : "HealthKit is not available in this Device"])
            if completion != nil {
                completion(false,error)
            }
            return
        }
        
        healthKitStore.requestAuthorization(toShare: nil , read: healthKitTypesToRead as? Set<HKObjectType>) { (success, error) in
            
            if completion != nil{
            
                completion(true,nil)
            }
            
        }
        
        
    }
    
    
    //读取步数
    func getStepCount(completion: ((_ value:Double, _ error:NSError?) -> Void)!) {
        
        let stepType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: stepType!, predicate: self.predicateForSamplesToday(), limit: HKObjectQueryNoLimit, sortDescriptors: [timeSortDescriptor]) { (query, results, error) in
            
            if (error != nil) {
                completion(-10,error! as NSError)
            }else{
            
                var totleStrps = 0.0;
                
                for quantitySample in results!{
                    
                    let qu = quantitySample as! HKQuantitySample
                    
                    let quantity = qu.quantity
                    
                    
                    
                    let heightUnit = HKUnit.count()

                    let userHeight = quantity.doubleValue(for: heightUnit)

                    totleStrps += Double(userHeight)
                    
                }
                
                
                let error = NSError()
                
                completion(totleStrps,error)
            }
            
        }
        
        self.healthKitStore.execute(query)
        
    }
    
    
    //读取距离
    func getDistance(completion: ((_ value:Double, _ error:NSError?) -> Void)!){
        
        let distanceType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        
        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: distanceType!, predicate: HealthManager().predicateForSamplesToday(), limit: HKObjectQueryNoLimit, sortDescriptors: [timeSortDescriptor]) { (query, result, error) in
            
            if error != nil{
                
                completion(-10,error! as NSError)
                
            }else{
                
                var totleStrps = 0.0;
                
                for quantitySample in result!{
                    
                    let qu = quantitySample as! HKQuantitySample
                    
                    let quantity = qu.quantity
                    
                    
                    
                    let heightUnit = HKUnit.meterUnit(with: HKMetricPrefix.kilo)
                    
                    let userHeight = quantity.doubleValue(for: heightUnit)
                    
                    totleStrps += Double(userHeight)
                    
                }

                let error = NSError()
                
                completion(totleStrps,error);
            }
            
        }
        
        self.healthKitStore.execute(query)
    }
    
    
    func predicateForSamplesToday() -> NSPredicate{
        let caledar = NSCalendar.current
        let now = Date()
        let componsents = NSDateComponents()
        componsents.year = caledar.component(.year, from: now)
        componsents.month = caledar.component(.month, from: now)
        componsents.day = caledar.component(.day, from: now)
        componsents.hour = 0
        componsents.minute = 0
        componsents.second = 0
        
        let startDate = caledar.date(from: componsents as DateComponents)
//        let endDate = caledar.date(byAdding: NSCalendar.Unit.day, value: 1, to: startDate!)
        
        let endDate = caledar.date(byAdding: Calendar.Component.day, value: 1, to: startDate!)
       
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions(rawValue: 0))
        return predicate
        
    }
    
    
    
}


