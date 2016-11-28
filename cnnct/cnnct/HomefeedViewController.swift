//
//  HomefeedViewController.swift
//  cnnct
//
//  Created by Anthony Wamunyu Maina on 11/27/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

import UIKit

class HomefeedViewController: UIViewController {
    
    
    var pageMenu : CAPSPageMenu?
    let PRIMARY_APP_COLOR = UIColor(red: 2.0/255.0, green: 208.0/255.0, blue: 172.0/255.0, alpha: 1.0)
    
    let controller1 : InterestsViewController = InterestsViewController()
    let controller2 : PeopleTableViewController = PeopleTableViewController()
    
    var controllerArray : [UIViewController] = []
    
    var noOfTimesControllerCameIntoView = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isTranslucent = false
        
        
        // MARK: - Scroll menu setup
        let controller1 : InterestsViewController = InterestsViewController()
        controllerArray.append(controller1)
        let controller2 : PeopleTableViewController = PeopleTableViewController()
        controllerArray.append(controller2)
        self.extendedLayoutIncludesOpaqueBars = false;
        //self.edgesForExtendedLayout = UIRectEdge.none;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
          if(noOfTimesControllerCameIntoView < 1){
            self.navigationController?.navigationBar.topItem?.title = "Cnct"
            
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            //self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
            self.navigationController?.navigationBar.tintColor = UIColor.white
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: PRIMARY_APP_COLOR,NSFontAttributeName:UIFont.systemFont(ofSize: 30, weight: UIFontWeightThin)]

            // MARK: - Scroll menu setup
            // Initialize view controllers to display and place in array
            controllerArray = []
            controller1.title = "EVENT INTERESTS"
            controllerArray.append(controller1)
            controller2.title = "CONNECT WITH ATTENDEES"
            controllerArray.append(controller2)

            
            // Customize menu (Optional)
            let parameters: [CAPSPageMenuOption] = [
                .ScrollMenuBackgroundColor(UIColor.white),
                //.ViewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
                .SelectionIndicatorColor(PRIMARY_APP_COLOR),
                .BottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
                .MenuItemFont(UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)),
                .MenuHeight(40.0),
                .MenuItemWidth(90.0),
                .CenterMenuItems(true)
            ]

            // Initialize scroll menu
            
//            pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(0.0,0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
            
//
//            self.addChildViewController(pageMenu!)
//            
//            self.view.addSubview(pageMenu!.view)
//            
//            pageMenu!.didMove(toParentViewController: self)
//            
//            
        }
        noOfTimesControllerCameIntoView += 1
        
    }
    
    
    func didTapGoToLeft() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0 {
            pageMenu!.moveToPage(index: currentIndex - 1)
        }
    }
    
    func didTapGoToRight() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex < pageMenu!.controllerArray.count {
            pageMenu!.moveToPage(index: currentIndex + 1)
        }
    }
    
    // MARK: - Container View Controller
    public class var shouldAutomaticallyForwardAppearanceMethods:Swift.Bool {
        get {
            return true
        }
    }
    
    
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
