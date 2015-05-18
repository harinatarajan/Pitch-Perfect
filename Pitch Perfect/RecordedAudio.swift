//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Sudha Subramanian on 5/12/15.
//  Copyright (c) 2015 Sudha Subramanian. All rights reserved.
//

import Foundation
class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(url: NSURL, t: String) {
        self.filePathUrl = url
        self.title = t
    }
}