//
//  SecondViewController.h
//  WeRide
//
//  Created by Dian Wen on 7/24/15.
//  Copyright (c) 2015 Dian Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UberKit.h"
@interface SecondViewController : UIViewController<UberKitDelegate>
@property(nonatomic, retain) NSString *receiptID;

@end

