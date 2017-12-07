//
//  SplitRowValue.swift
//  Valletti
//
//  Created by Marco Betschart on 30.11.17.
//  Copyright © 2017 MANDELKIND. All rights reserved.
//

import Eureka

public struct SplitRowValue<L: Equatable, R: Equatable>{
	public var left: L?
	public var right: R?
	
	public init(left: L?, right: R?){
		self.left = left
		self.right = right
	}
	
	public init(){}
}

extension SplitRowValue: Equatable{
	public static func == (lhs: SplitRowValue, rhs: SplitRowValue) -> Bool{
		return lhs.left == rhs.left && lhs.right == rhs.right
	}
}
