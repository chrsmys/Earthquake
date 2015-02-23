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
    
    //Set the settings button to a cog
    // List of unicode characters in FontAwesome
    // http://fortawesome.github.io/Font-Awesome/cheatsheet/
    [_settingsButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"FontAwesome" size:26.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    _settingsButton.title=@"\uf013";
    
    [self subscribeToEvents];
    
    self.eventMapView.delegate=self;
    
    [self.eventMapView setNeedsDisplay];
    [self changeAnnotationsWithEvents:_eventList];
    
    //Get the current maptype from the settings service
    [self.eventMapView setMapType:[[CAMSettingsServices sharedInstance] mapType]];
}

#pragma mark - Settings Observers

//Adds self as an observer to notifications it should be aware of
- (void)subscribeToEvents{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mapTypeChanged) name:@"MapTypeChanged" object:nil];
}

//Unscubscribes self to all events
- (void)unsubscribeToEvents{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//Updates the map type to the settings maptype
- (void)mapTypeChanged{
    [self.eventMapView setMapType:[[CAMSettingsServices sharedInstance] mapType]];
}

#pragma mark - Event Changes

- (void)setEventList:(NSArray *)eventList{
    _eventList=eventList;
    [self changeAnnotationsWithEvents:_eventList];
}

/*
    Adds annotations to the map and zooms to the annotations
 */
- (void)changeAnnotationsWithEvents:(NSArray *)eventList{
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



#pragma mark - MapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@""];
    pin.image=[UIImage imageNamed:@"annotation.png"];
    pin.canShowCallout = YES;
    pin.annotation=annotation;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.rightCalloutAccessoryView = button;
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    if ([view.annotation isKindOfClass:[CamEvent class]]){
        //Display event detail controller
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
            if (finished && aV) {
                aV.image=[UIImage imageNamed:@"annotationCrack.png"];

            }
        }];
    }
}

#pragma mark - Map Helper Methods

/*
    Handles zooming to a particular annotation on the eventmap
 */
- (void)zoomMapToAnnotation:(id<MKAnnotation>)annotation{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
