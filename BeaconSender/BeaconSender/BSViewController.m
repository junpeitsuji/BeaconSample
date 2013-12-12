//
//  BSViewController.m
//  BeaconSender
//
//  Created by suwa_yuki on 2013/10/01.
//  Copyright (c) 2013年 suwa.yuki. All rights reserved.
//

#import "BSViewController.h"

@interface BSViewController ()

@end

@implementation BSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 生成したUUIDからNSUUIDを作成
    self.proximityUUID = [[NSUUID alloc] initWithUUIDString:@"1E21BCE0-7655-4647-B492-A3F8DE2F9A02"];
    // CBPeripheralManagerを作成
    self.manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)startAdvertising:(NSInteger)minor
{
    NSLog(@"beacon minor=%ld", (long)minor);
    // CLBeaconRegionを作成してアドバタイズするデータを取得
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID
                                                                           major:1
                                                                           minor:minor
                                                                      identifier:@"jp.classmethod.testregion"];
    NSDictionary *beaconPeripheralData = [beaconRegion peripheralDataWithMeasuredPower:nil];
    [self.manager stopAdvertising];
    // アドバタイズを開始
    [self.manager startAdvertising:beaconPeripheralData];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"CBPeripheralManagerStatePoweredOn");
            // まずはBeaconAを起動
            [self.firstSwitch setOn:YES];
            [self startAdvertising:1];
            break;
        case CBPeripheralManagerStatePoweredOff:
            NSLog(@"CBPeripheralManagerStatePoweredOff");
            break;
        case CBPeripheralManagerStateResetting:
            NSLog(@"CBPeripheralManagerStateResetting");
            break;
        case CBPeripheralManagerStateUnauthorized:
            NSLog(@"CBPeripheralManagerStateUnauthorized");
            break;
        case CBPeripheralManagerStateUnknown:
            NSLog(@"CBPeripheralManagerStateUnknown");
            break;
        case CBPeripheralManagerStateUnsupported:
            NSLog(@"CBPeripheralManagerStateUnsupported");
            break;
    }
}

- (IBAction)didFirstSwitchValueChange:(id)sender {
    if ([self.firstSwitch isOn]) {
        [self startAdvertising:1];
        [self.secondSwitch setOn:NO];
        [self.thirdSwitch setOn:NO];
    } else {
        [self.manager stopAdvertising];
    }
}

- (IBAction)didSecondSwitchValueChanged:(id)sender {
    if ([self.secondSwitch isOn]) {
        [self startAdvertising:2];
        [self.firstSwitch setOn:NO];
        [self.thirdSwitch setOn:NO];
    } else {
        [self.manager stopAdvertising];
    }
}

- (IBAction)didThirdSwitchValueChanged:(id)sender {
    if ([self.thirdSwitch isOn]) {
        [self startAdvertising:3];
        [self.firstSwitch setOn:NO];
        [self.secondSwitch setOn:NO];
    } else {
        [self.manager stopAdvertising];
    }
}

@end
