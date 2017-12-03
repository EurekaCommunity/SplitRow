//
//  SplitValues.swift
//  Valletti
//
//  Created by Marco Betschart on 30.11.17.
//  Copyright © 2017 MANDELKIND. All rights reserved.
//

import Eureka

public struct SplitValues<L: Equatable, R: Equatable>{
	public var left: L?
	public var right: R?
	
	init(){}
}

extension SplitValues: Equatable{
	public static func == (lhs: SplitValues, rhs: SplitValues) -> Bool{
		return lhs.left == rhs.left && lhs.right == rhs.right
	}
}
