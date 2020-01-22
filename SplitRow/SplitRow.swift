//
//  SplitRow.swift
//  Valletti
//
//  Created by Marco Betschart on 01.12.17.
//  Copyright © 2017 MANDELKIND. All rights reserved.
//

import Eureka
import UIKit

open class _SplitRow<L: RowType, R: RowType>: Row<SplitRowCell<L,R>> where L: BaseRow, R: BaseRow{
	
	open override var section: Section?{
		get{ return super.section }
		set{
			rowLeft?.section = newValue
			rowRight?.section = newValue
			
			super.section = newValue
		}
	}
	
	open override func updateCell(){
		super.updateCell()
		
		self.rowLeft?.updateCell()
		self.rowLeft?.cell?.selectionStyle = .none
		
		self.rowRight?.updateCell()
		self.rowRight?.cell?.selectionStyle = .none
	}
	
	private(set) public var valueChanged = Set<SplitRowTag>()
	
	open override var value: SplitRowValue<L.Cell.Value, R.Cell.Value>?{
		get{ return super.value }
		set{
			valueChanged = []
			if super.value?.left != newValue?.left {
				valueChanged.insert(.left)
			}
			if super.value?.right != newValue?.right {
				valueChanged.insert(.right)
			}
			
			if self.rowLeft?.value != newValue?.left{
				self.rowLeft?.value = newValue?.left
				valueChanged.insert(.left)
			}
			
			if self.rowRight?.value != newValue?.right{
				self.rowRight?.value = newValue?.right
				valueChanged.insert(.right)
			}
			
			if false == valueChanged.isEmpty{
				super.value = newValue
			}
		}
	}
	
	public enum SplitRowTag: String{
		case left,right
	}
	
	public var rowLeft: L?{
		willSet{
			newValue?.tag = SplitRowTag.left.rawValue
			guard let row = newValue else{ return }
			
			var rowValue = self.value ?? SplitRowValue<L.Cell.Value,R.Cell.Value>()
			rowValue.left = row.value
			self.value = rowValue
			
			subscribe(onChange: row)
			subscribe(onCellHighlightChanged: row)
		}
	}
    
    /// The left rows background color.
    /// - note: Use `cell.backgroundColor` to change the entire row's background color.
    public var rowLeftBackgroundColor: UIColor? {
        get { return cell.tableViewLeft.backgroundColor }
        set { cell.tableViewLeft.backgroundColor = newValue }
    }
    
	public var rowLeftPercentage: CGFloat = 0.3
	
	public var rowRight: R?{
		willSet{
			newValue?.tag = SplitRowTag.right.rawValue
			guard let row = newValue else{ return }
			
			var rowValue = self.value ?? SplitRowValue<L.Cell.Value,R.Cell.Value>()
			rowValue.right = row.value
			self.value = rowValue
			
			subscribe(onChange: row)
			subscribe(onCellHighlightChanged: row)
		}
	}
    
    /// The right rows background color.
    /// - note: Use `cell.backgroundColor` to change the entire row's background color.
    public var rowRightBackgroundColor: UIColor? {
        get { return cell.tableViewRight.backgroundColor }
        set { cell.tableViewRight.backgroundColor = newValue }
    }
	
	public var rowRightPercentage: CGFloat{
		return 1.0 - self.rowLeftPercentage
	}
	
	required public init(tag: String?) {
		super.init(tag: tag)
		cellProvider = CellProvider<SplitRowCell<L,R>>()
	}
	
	open func subscribe<T: RowType>(onChange row: T) where T: BaseRow{
		row.onChange{ [weak self] row in
			guard let strongSelf = self, let rowTagString = row.tag, let rowTag = SplitRowTag(rawValue: rowTagString) else{ return }
			strongSelf.cell?.update()  //TODO: This should only be done on cells which need an update. e.g. PushRow etc.
			
			var value = SplitRowValue<L.Cell.Value,R.Cell.Value>()
			if rowTag == .left {
				value.left = row.value as? L.Cell.Value
				value.right = strongSelf.value?.right
			} else if rowTag == .right {
				value.right = row.value as? R.Cell.Value
				value.left = strongSelf.value?.left
			}
			
			strongSelf.value = value
		}
	}
	
	open func subscribe<T: RowType>(onCellHighlightChanged row: T) where T: BaseRow{
		row.onCellHighlightChanged{ [weak self] cell, row in
			guard let strongSelf = self,
				let splitRowCell = strongSelf.cell,
				let formViewController = strongSelf.cell.formViewController()
				else { return }

			if cell.isHighlighted || row.isHighlighted {
				formViewController.beginEditing(of: splitRowCell)
			} else {
				formViewController.endEditing(of: splitRowCell)
			}
		}
	}
}

public final class SplitRow<L: RowType, R: RowType>: _SplitRow<L,R>, RowType where L: BaseRow, R: BaseRow{}
