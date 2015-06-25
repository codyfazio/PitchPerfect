//
//  RecordAudio.swift
//  Pitch Perfect
//
//  Created by Cody Clingan on 3/24/15.
//  Copyright (c) 2015 Cody Fazio. All rights reserved.
//

import Foundation


class RecordedAudio: NSObject {
    var title: String!
    var filePathUrl: NSURL!
    
    
    init(filePathUrl: NSURL, title: String){
        self.title = title
        self.filePathUrl = filePathUrl
        
    }
}
