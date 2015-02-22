//
//  CAMMapViewController.m
//  Earthquake
//
//  Created by Chris Mays on 2/20/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

#import "CAMMapViewController.h"
#import "CamEvent.h"
#import "CAMEventAnnotation.h"
@interface CAMMapViewController ()

@end

@implementation CAMMapViewController
@synthesize eventMapView=_eventMapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventMapView.delegate=self;
    [self changeAnnotationsWithEvents:_eventList];
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
        CAMEventAnnotation *anotation = [[CAMEventAnnotation alloc] initWithCamEvent:event];
        [self.eventMapView addAnnotation:anotation];
        [self zoomMapToAnnotation:anotation];
    }
    
    //If there are multiple annotations let mapview handle fitting all in map
    if ([[self.eventMapView annotations] count]>1) {
        [self.eventMapView showAnnotations:[self.eventMapView annotations] animated:true];
    }
}

#pragma MapView Delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@""];
    pin.canShowCallout = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.rightCalloutAccessoryView = button;
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    [self performSegueWithIdentifier:@"ShowAnnotationDetail" sender:nil];
}

-(void)zoomMapToAnnotation:(id<MKAnnotation>)annotation{
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake([annotation coordinate], MKCoordinateSpanMake(4.0, 4.0));
    [self.eventMapView setRegion:mapRegion animated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
