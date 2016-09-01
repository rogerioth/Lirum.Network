//
//  ViewController.m
//  Lirum.Network.Test
//
//  Created by Rogerio Hirooka on 2/26/16.
//  Copyright © 2016 Lirum. All rights reserved.
//

#import "ViewController.h"
#import "Lirum_Network.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Lirum_Network * l = [[Lirum_Network alloc] init];
    NSMutableDictionary *m = [l getConnections];
    
    [Lirum_Network initializeNetworkElements];

    NSLog(@"Connections: %@", m);
    
    NSLog(@"WWAN IP: %@", [Lirum_Network getWWanIP]);
    NSLog(@"Wifi IP: %@", [Lirum_Network getWifiIP]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
