//
//  BaseModulRouter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import Foundation
import UIKit

protocol BaseModulRouterProtocol {
    var builder: ModuleBuilder? {get set}
    var viewController: UIViewController? {get}
}
