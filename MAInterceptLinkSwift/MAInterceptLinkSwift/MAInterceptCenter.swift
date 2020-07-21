//
//  MAInterceptCenter.swift
//  MAInterceptLinkSwift
//
//  Created by hugengya on 2020/5/11.
//  Copyright © 2020 com.hefeichenye. All rights reserved.
//

import UIKit

public class MAInterceptCenter: NSObject {

}

private class InterceptProtocol: URLProtocol {

    static let SOURURL:String = "";
    static let  LOCALURL:String = "";
    private static let FilterProtocolURLHandledKey:String = "";
    
    public static var Params:NSDictionary = {};
    static ResultParams:NSDictionary;
    static InterceptLog:Bool;
    static InerceptTargetLog:Bool;
}
