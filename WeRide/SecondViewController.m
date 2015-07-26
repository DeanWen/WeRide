//
//  SecondViewController.m
//  WeRide
//
//  Created by Dian Wen on 7/24/15.
//  Copyright (c) 2015 Dian Wen. All rights reserved.
//

#import "SecondViewController.h"
#import "UberKit.h"


@interface SecondViewController ()

@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    _receiptID = nil;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self callCientAuthenticationMethods];
}

- (void) callCientAuthenticationMethods
{
    UberKit *uberKit = [[UberKit alloc] initWithServerToken:@"vTvzxqyFRw-NTGxgIeQjHcVCm27TVlAJrH96rcvp"]; //Add your server token
    //[[UberKit sharedInstance] setServerToken:@"YOUR_SERVER_TOKEN"]; //Alternate initialization
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:37.7833 longitude:-122.4167];
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:37.9 longitude:-122.43];
    
    [uberKit getProductsForLocation:location withCompletionHandler:^(NSArray *products, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberProduct *product = [products objectAtIndex:0];
             NSLog(@"Product name of first %@", product.product_description);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getTimeForProductArrivalWithLocation:location withCompletionHandler:^(NSArray *times, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberTime *time = [times objectAtIndex:0];
             NSLog(@"Time for first %f", time.estimate);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getPriceForTripWithStartLocation:location endLocation:endLocation  withCompletionHandler:^(NSArray *prices, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberPrice *price = [prices objectAtIndex:0];
             NSLog(@"Price for first %i", price.lowEstimate);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getPromotionForLocation:location endLocation:endLocation withCompletionHandler:^(UberPromotion *promotion, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             NSLog(@"Promotion - %@", promotion.localized_value);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
}

- (IBAction)login:(id)sender
{
    [[UberKit sharedInstance] setClientID:@"TRoQcMg6E3QrqVzNTt6-tjoGcIIJq7FU"];
    [[UberKit sharedInstance] setClientSecret:@"5gz7mKnnU9XxeuH-3yVYHGpestBWzhhdnhkaieOU"];
    [[UberKit sharedInstance] setRedirectURL:@"weride://response"];
    [[UberKit sharedInstance] setApplicationName:@"WERIDE"];
    
    UberKit *uberKit = [UberKit sharedInstance];
    uberKit.delegate = self;
    [uberKit startLogin];
}

- (void) uberKit:(UberKit *)uberKit didReceiveAccessToken:(NSString *)accessToken
{
    NSLog(@"Received access token %@", accessToken);
    if(accessToken)
    {
        [uberKit getUserActivityWithCompletionHandler:^(NSArray *activities, NSURLResponse *response, NSError *error)
         {
             if(!error)
             {
                 NSLog(@"User activity %@", activities);
                 
                 if (activities.count != 0) {
                     UberActivity *activity = [activities objectAtIndex:0];
                     NSLog(@"Last trip distance %f", activity.distance);
                     _receiptID = activity.uiud;
                     NSLog(@"receipt id is %@", _receiptID);
                     
                     [uberKit getuserLastReceipt:_receiptID withCompletionHandler:^(NSArray *resultsArray, NSURLResponse *response, NSError *error) {
                         if(!error)
                         {
                             NSLog(@"User Receipt %@", [resultsArray objectAtIndex:0]);
                         }
                         else
                         {
                             NSLog(@"Error %@", error);
                         }
                     }];
                     
                     
                 }else{
                     NSLog(@"empty activities");
                 }
                 
             }
             else
             {
                 NSLog(@"Error %@", error);
             }
         }];
        
        

        
        [uberKit getUserProfileWithCompletionHandler:^(UberProfile *profile, NSURLResponse *response, NSError *error)
         {
             if(!error)
             {
                 NSLog(@"User's full name %@ %@", profile.first_name, profile.last_name);
             }
             else
             {
                 NSLog(@"Error %@", error);
             }
         }];
    }
    else
    {
        NSLog(@"No auth token, try again");
    }
}

- (void) uberKit:(UberKit *)uberKit loginFailedWithError:(NSError *)error
{
    NSLog(@"Error in login %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end