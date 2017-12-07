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
		get{ return super.section }
		set{
			rowLeft?.section = newValue
			rowRight?.section = newValue
			
			super.section = newValue
		}
	}
	
	public override func updateCell(){
		super.updateCell()
		
		self.rowLeft?.updateCell()
		self.rowRight?.updateCell()
	}
	
	public override var value: SplitRowValue<L.Cell.Value, R.Cell.Value>?{
		get{ return super.value }
		set{
			var wasChanged = super.value?.left != newValue?.left || super.value?.right != newValue?.right
			
			if self.rowLeft?.value != newValue?.left{
				self.rowLeft?.value = newValue?.left
				wasChanged = true
			}
			
			if self.rowRight?.value != newValue?.right{
				self.rowRight?.value = newValue?.right
				wasChanged = true
			}
			
			if wasChanged{
				super.value = newValue
			}
		}
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
			
			var value = SplitRowValue<L.Cell.Value,R.Cell.Value>()
			
			if side == .left{
				value.left = $0.value as? L.Cell.Value
				value.right = this.value?.right
				
			} else if side == .right{
				value.right = $0.value as? R.Cell.Value
				value.left = this.value?.left
			}
			
			this.value = value
		}
	}
}
