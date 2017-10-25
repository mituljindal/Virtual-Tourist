//
//  GCDBlackBox.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 25/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
