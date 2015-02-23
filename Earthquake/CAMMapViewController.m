//
//  CAMMapViewController.m
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "CAMMapViewController.h"
#import "CamEvent.h"
#import "CAMEventDetailViewController.h"
#import "CAMSettingsServices.h"
@interface CAMMapViewController ()

@end

@implementation CAMMapViewController
@synthesize eventMapView=_eventMapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventMapView.delegate=self;
    [self changeAnnotationsWithEvents:_eventList];
    [_settingsButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"FontAwesome" size:26.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
    _settingsButton.title=@"\uf013";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mapTypeChanged) name:@"MapTypeChanged" object:nil];
    [self.eventMapView setMapType:[[CAMSettingsServices sharedInstance] mapType]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setEventList:(NSArray *)eventList{
    _eventList=eventList;
    [self changeAnnotationsWithEvents:_eventList];
}

-(void)changeAnnotationsWithEvents:(NSArray *)eventList{
    [self.eventMapView removeAnnotations:[self.eventMapView annotations]];
    
    for (CamEvent *event in eventList) {
      //  CAMEventAnnotation *anotation = [[CAMEventAnnotation alloc] initWithCamEvent:event];
        [self.eventMapView addAnnotation:event];
        [self zoomMapToAnnotation:event];
    }
    
    //If there are multiple annotations let mapview handle fitting all in map
    if ([[self.eventMapView annotations] count]>1) {
        [self.eventMapView showAnnotations:[self.eventMapView annotations] animated:true];
    }
}

-(void)mapTypeChanged{
    [self.eventMapView setMapType:[[CAMSettingsServices sharedInstance] mapType]];
}

#pragma MapView Delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@""];
    pin.image=[UIImage imageNamed:@"annotation.png"];
    pin.canShowCallout = YES;
    pin.annotation=annotation;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.rightCalloutAccessoryView = button;
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    if ([view.annotation isKindOfClass:[CamEvent class]]){
        CamEvent *event = view.annotation;
        recentlySelectedEvent=event;
        [self performSegueWithIdentifier:@"ShowAnnotationDetail" sender:event];
    }
}

/**
    Perform drop annotation animation
 
    Code Derived from StackOverflow
 */
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    
    for (aV in views) {
        
        // Don't pin drop if annotation is user location
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.eventMapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.view.frame.size.height, aV.frame.size.width, aV.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04*[views indexOfObject:aV] options: UIViewAnimationOptionCurveLinear animations:^{
            
            aV.frame = endFrame;
            
            // Animate squash
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    
                }completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            aV.transform = CGAffineTransformIdentity;
                            aV.image=[UIImage imageNamed:@"annotationCrack.png"];
                            if(aV && aV.annotation){
                                [mapView selectAnnotation:aV.annotation animated:true];
                            }
                        }];
                    }
                }];
            }
        }];
    }
}

-(void)zoomMapToAnnotation:(id<MKAnnotation>)annotation{
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake([annotation coordinate], MKCoordinateSpanMake(4.0, 4.0));
    [self.eventMapView setRegion:mapRegion animated:true];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowAnnotationDetail"]) {
        id tempDestination = segue.destinationViewController;
        if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
            tempDestination = [(UINavigationController *)tempDestination topViewController];
        }
        
        CAMEventDetailViewController *destination = tempDestination;
        destination.currentEvent = recentlySelectedEvent;
    }
}


@end
