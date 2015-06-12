//
//  SegueHandlerType.swift
//  Campuswelle
//
//  Created by Valentin Knabel on 12.06.15.
//  Copyright © 2015 Valentin Knabel. All rights reserved.
//

import UIKit

protocol SegueHandlerType {
    typealias SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where
    Self: UIViewController,
    SegueIdentifier.RawValue == String
{
    //handleSegue with guard
    // There is a sample project
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier,
            segueIdentifier = SegueIdentifier(rawValue: identifier)
            else { fatalError("Unknown identifier \(segue.identifier)") }
        return segueIdentifier
    }
}
