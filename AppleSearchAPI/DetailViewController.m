//
//  DetailViewController.m
//  AppleSearchAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/17/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *collectionName;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)viewiniTunesActn:(id)sender;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionName.text = [self.detailInfo valueForKey:@"collectionName"];
    self.artistName.text = [self.detailInfo valueForKey:@"artistName"];
    self.priceLabel.text = [self setTrackPrice:[[self.detailInfo valueForKey:@"trackPrice"] floatValue]];
    self.dateLabel.text = [self setDate:[self.detailInfo valueForKey:@"releaseDate"]];
    self.timeLabel.text = [self setTrackTime:[[self.detailInfo valueForKey:@"trackTimeMillis"] integerValue]];
    self.imageView.image = self.image;
    //trackTimeMillis
    self.genreLabel.text = [self.detailInfo valueForKey:@"kind"];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.title = [self.detailInfo valueForKey:@"trackName"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)setDate:(NSString*)dateString{
    
    NSString *newDateString = [dateString substringWithRange:NSMakeRange(0, 10)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:newDateString];
    [dateFormatter setDateFormat:@"d MMM, YYYY"];
    return [dateFormatter stringFromDate:date];
   
}
-(NSString*)setTrackPrice:(float)value{
    if(value<0){
        return @"Album Only";
    }
    return [NSString stringWithFormat:@"$%0.2f",value];
    
}
-(NSString*)setTrackTime:(NSInteger)trackTime{
    
    trackTime = trackTime/1000;
    long min = trackTime/60;
    long sec = trackTime % 60;
    return [NSString stringWithFormat:@"%ld:%0.2ld min",min,sec];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)viewiniTunesActn:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.detailInfo valueForKey:@"trackViewUrl"]]];
}
@end
