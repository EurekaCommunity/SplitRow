//
//  SplitRow.swift
//  Valletti
//
//  Created by Marco Betschart on 01.12.17.
//  Copyright © 2017 MANDELKIND. All rights reserved.
//

import Eureka

public final class SplitRow<L: RowType, R: RowType>: Row<SplitRowCell<L,R>>, RowType where L: BaseRow, R: BaseRow{
	
	public override var section: Section?{
		set{
			rowLeft?.section = newValue
			rowRight?.section = newValue
			
			super.section = newValue
		}
		get{ return super.section }
	}
	
	private enum Side{
		case right,left
	}
	
	public var rowLeft: L?{ willSet{ if let row = newValue{ bindOnChange(row, to: .left) } } }
	public var rowLeftPercentage: CGFloat = 0.3
	
	public var rowRight: R?{ willSet{ if let row = newValue{ bindOnChange(row, to: .right) } } }
	public var rowRightPercentage: CGFloat{
		return 1.0 - self.rowLeftPercentage
	}
	
	required public init(tag: String?) {
		super.init(tag: tag)
		cellProvider = CellProvider<SplitRowCell<L,R>>()
	}

	private func bindOnChange<T: RowType>(_ row: T, to side: Side) where T: BaseRow{
		row.onChange{ [weak self] in
			guard let this = self else{ return }
			this.cell?.update() //TODO: This should only be done on cells which need an update. e.g. PushRow etc.
			
			var values = SplitValues<L.Cell.Value,R.Cell.Value>()
			
			if side == .left{
				values.left = $0.value as? L.Cell.Value
				values.right = this.value?.right
				
			} else if side == .right{
				values.right = $0.value as? R.Cell.Value
				values.left = this.value?.left
			}
			
			this.value = values
		}
	}
}
