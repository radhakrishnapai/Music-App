//
//  ArtistsViewController.swift
//  Music App
//
//  Created by qbuser on 30/08/16.
//  Copyright © 2016 Pai. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class ArtistsViewController: UIViewController {
    override func viewDidLoad() {
        let query = MPMediaQuery.artistsQuery()
    }
}