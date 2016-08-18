//
//  MyMusicViewController.swift
//  Music App
//
//  Created by qbuser on 18/08/16.
//  Copyright © 2016 Pai. All rights reserved.
//

import Foundation
import UIKit
import SJSegmentedScrollView

class MyMusicViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        if let storyboard = self.storyboard {
            self.tabBarItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFontOfSize(12)], forState: UIControlState.Normal)
            let artists = storyboard.instantiateViewControllerWithIdentifier("Artists")
            let albums = storyboard.instantiateViewControllerWithIdentifier("Albums")
            let songs = storyboard.instantiateViewControllerWithIdentifier("Songs")
            let genres = storyboard.instantiateViewControllerWithIdentifier("Genres")
            let composers = storyboard.instantiateViewControllerWithIdentifier("Composers")
            let compilations = storyboard.instantiateViewControllerWithIdentifier("Compilations")
            let segmentedViewController = SJSegmentedViewController()
            segmentedViewController.headerViewController = UIViewController()
            segmentedViewController.headerViewHeight = 0
            segmentedViewController.segmentViewHeight = 60.0
            segmentedViewController.selectedSegmentViewHeight = 2.0
            segmentedViewController.selectedSegmentViewColor = UIColor.redColor()
            segmentedViewController.contentControllers = [artists, albums, songs, genres, composers, compilations]
            self.addChildViewController(segmentedViewController)
            self.view.addSubview(segmentedViewController.view)
            segmentedViewController.didMoveToParentViewController(self)
        }
    }
}