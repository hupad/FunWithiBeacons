//
//  TAViewController.m
//  FunWithiBeacons
//
//  Created by Harish on 11/22/13.
//  Copyright (c) 2013 tensorapps. All rights reserved.
//

#import "TAViewController.h"
#import <CoreLocation/CoreLocation.h>

#define BEACON_UUID @""

@interface TAViewController () <CLLocationManagerDelegate>

@property (nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation TAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@",[[NSUUID UUID] UUIDString]);
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:BEACON_UUID];
    
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.tensorapps.beaconfun.region"];
    
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    region.notifyEntryStateOnDisplay = YES;

    [self.locationManager startMonitoringForRegion:region];
    
    [self.locationManager requestStateForRegion:region];
}


-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
    if (state == CLRegionStateInside) {
        
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    }
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    
    
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
        CLBeaconRegion *beacon  = (CLBeaconRegion *)region;
        
        if ([beacon.identifier isEqualToString:@"com.tensorapps.beaconfun.region"]) {
            
            [self.locationManager startRangingBeaconsInRegion:beacon];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
        CLBeaconRegion *beacon  = (CLBeaconRegion *)region;
        
        if ([beacon.identifier isEqualToString:@"com.tensorapps.beaconfun.region"]) {
            
            [self.locationManager stopRangingBeaconsInRegion:beacon];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    for (CLBeacon *beacon in beacons) {
     
        NSLog(@"Rangin beacon: %@", beacon.proximityUUID);
        NSLog(@"%@ - %@", beacon.major, beacon.minor);
        
        NSLog(@"Range: %@", [self stringForProximity:beacon.proximity]);
        
        [self setColorForProperty:beacon.proximity];
    }
}

-(NSString *)stringForProximity:(CLProximity)proximity{
    
    switch(proximity){
            
        case CLProximityUnknown: return @"Unknown";
        case CLProximityFar: return @"Far";
        case CLProximityImmediate: return @"Immediate";
        case CLProximityNear: return @"very near";
        default:
            return nil;
    }
}

-(void)setColorForProperty:(CLProximity)proximity{
    
    switch (proximity) {
        case CLProximityUnknown:
            self.view.backgroundColor = [UIColor whiteColor];
            break;
            
        case CLProximityFar:
            self.view.backgroundColor = [UIColor yellowColor];
            break;
            
        case CLProximityNear:
            self.view.backgroundColor = [UIColor orangeColor];
            break;
            
        case CLProximityImmediate:
            self.view.backgroundColor = [UIColor redColor];
            break;
            
        default:
            break;
    }
}

@end
