//
//  GPCMLPAutoCompleteDemoViewController.m
//  MLPAutoCompleteDemoStoryboard
//
//  Created by Giorgio Piacentini on 05/07/14.
//
//

#import "GPCMLPAutoCompleteDemoViewController.h"

@interface GPCMLPAutoCompleteDemoViewController (){
    BOOL _suggestionsPicked;
    UITableView *_autoCompleteTableView;
}
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *autoCompleteTextField;

@end

@implementation GPCMLPAutoCompleteDemoViewController


- (IBAction)goToEventInterestsButton:(UIBarButtonItem *)sender {
    
    if((_autoCompleteTextField.text && _autoCompleteTextField.text.length > 0) && _suggestionsPicked){
        UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TabBarController"];
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    _suggestionsPicked = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - MLPAutoCompleteTextFieldDelegate

-(void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField didShowAutoCompleteTableView:(UITableView *)autoCompleteTableView{
    
    _autoCompleteTableView = autoCompleteTableView;
    
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedObject){
        NSLog(@"selected object from autocomplete menu %@ with string %@", selectedObject, [selectedObject autocompleteString]);
    } else {
        _suggestionsPicked = YES;
        NSLog(@"selected string '%@' from autocomplete menu", selectedString);
    }
}

@end
