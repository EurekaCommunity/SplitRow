//
//  SplitRowCell.swift
//  Valletti
//
//  Created by Marco Betschart on 30.11.17.
//  Copyright © 2017 MANDELKIND. All rights reserved.
//

import Eureka

open class SplitRowCell<L: RowType, R: RowType>: Cell<SplitRowValue<L.Cell.Value,R.Cell.Value>>, CellType where L: BaseRow, R: BaseRow{
	var tableViewLeft: SplitRowCellTableView<L>!
	var tableViewRight: SplitRowCellTableView<R>!
	
	public required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.tableViewLeft = SplitRowCellTableView()
		tableViewLeft.separatorStyle = .none
		tableViewLeft.leftSeparatorStyle = .none
		tableViewLeft.translatesAutoresizingMaskIntoConstraints = false
		
		self.tableViewRight = SplitRowCellTableView()
		tableViewRight.separatorStyle = .none
		tableViewRight.leftSeparatorStyle = .singleLine
		tableViewRight.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.addSubview(tableViewLeft)
		contentView.addConstraint(NSLayoutConstraint(item: tableViewLeft, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 0.0))
		
		contentView.addSubview(tableViewRight)
		contentView.addConstraint(NSLayoutConstraint(item: tableViewRight, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: 0.0))
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	open override func setup(){
		selectionStyle = .none
		
		//ignore Xcode Cast warning here, it works!
		guard let row = self.row as? SplitRow<L,R> else{ return }
		
		//TODO: If we use UITableViewAutomaticDimension instead of 44.0 we encounter constraint errors :(
		let maxRowHeight = max(row.rowLeft?.cell?.height?() ?? 44.0, row.rowRight?.cell?.height?() ?? 44.0)
		if maxRowHeight != UITableViewAutomaticDimension{
			self.height = { maxRowHeight }
			row.rowLeft?.cell?.height = self.height
			row.rowRight?.cell?.height = self.height
		}
		
		tableViewLeft.row = row.rowLeft
		tableViewLeft.isScrollEnabled = false
		tableViewLeft.setup()
		
		tableViewRight.row = row.rowRight
		tableViewRight.isScrollEnabled = false
		tableViewRight.setup()
		
		setupConstraints()
	}
	
	
	open override func update(){
		tableViewLeft.update()
		tableViewRight.update()
	}
	
	private func setupConstraints(){
		guard let row = self.row as? SplitRow<L,R> else{ return }
		
		if let height = self.height?(){
			self.contentView.addConstraint(NSLayoutConstraint(item: tableViewLeft, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: height))
			self.contentView.addConstraint(NSLayoutConstraint(item: tableViewRight, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: height))
		}
		
		self.contentView.addConstraint(NSLayoutConstraint(item: tableViewLeft, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: row.rowLeftPercentage, constant: 0.0))
		self.contentView.addConstraint(NSLayoutConstraint(item: tableViewRight, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: row.rowRightPercentage, constant: 0.0))
	}
	
	private func rowCanBecomeFirstResponder(_ row: BaseRow?) -> Bool{
		guard let row = row else{ return false }
		return false == row.isDisabled && row.baseCell?.cellCanBecomeFirstResponder() ?? false
	}
	
	open override var isFirstResponder: Bool{
		guard let row = self.row as? SplitRow<L,R> else{ return false }
		
		let rowLeftFirstResponder = row.rowLeft?.cell.findFirstResponder()
		let rowRightFirstResponder = row.rowRight?.cell?.findFirstResponder()
		
		return rowLeftFirstResponder != nil || rowRightFirstResponder != nil
	}
	
	open override func cellCanBecomeFirstResponder() -> Bool{
		guard let row = self.row as? SplitRow<L,R> else{ return false }
		guard false == row.isDisabled else{ return false }
		
		let rowLeftFirstResponder = row.rowLeft?.cell.findFirstResponder()
		let rowRightFirstResponder = row.rowRight?.cell?.findFirstResponder()
		
		if rowLeftFirstResponder == nil && rowRightFirstResponder == nil{
			return rowCanBecomeFirstResponder(row.rowLeft) || rowCanBecomeFirstResponder(row.rowRight)
		
		} else if rowLeftFirstResponder == nil{
			return rowCanBecomeFirstResponder(row.rowLeft)
			
		} else if rowRightFirstResponder == nil{
			return rowCanBecomeFirstResponder(row.rowRight)
		}
		
		return false
	}
	
	open override func cellBecomeFirstResponder(withDirection: Direction) -> Bool {
		guard let row = self.row as? SplitRow<L,R> else{ return false }
		
		let rowLeftFirstResponder = row.rowLeft?.cell.findFirstResponder()
		let rowLeftCanBecomeFirstResponder = rowCanBecomeFirstResponder(row.rowLeft)
		
		let rowRightFirstResponder = row.rowRight?.cell?.findFirstResponder()
		let rowRightCanBecomeFirstResponder = rowCanBecomeFirstResponder(row.rowRight)
		
		if withDirection == .down{
			if rowLeftFirstResponder == nil, rowLeftCanBecomeFirstResponder{
				return row.rowLeft?.cell?.cellBecomeFirstResponder(withDirection: withDirection) ?? false
				
			} else if rowRightFirstResponder == nil, rowRightCanBecomeFirstResponder{
				return row.rowRight?.cell?.cellBecomeFirstResponder(withDirection: withDirection) ?? false
			}
			
		} else if withDirection == .up{
			if rowRightFirstResponder == nil, rowRightCanBecomeFirstResponder{
				return row.rowRight?.cell?.cellBecomeFirstResponder(withDirection: withDirection) ?? false
				
			} else if rowLeftFirstResponder == nil, rowLeftCanBecomeFirstResponder{
				return row.rowLeft?.cell?.cellBecomeFirstResponder(withDirection: withDirection) ?? false
			}
		}
		
		return false
	}
	
	open override func cellResignFirstResponder() -> Bool{
		guard let row = self.row as? SplitRow<L,R> else{ return false }
		
		let rowLeftResignFirstResponder = row.rowLeft?.cell?.cellResignFirstResponder() ?? false
		let rowRightResignFirstResponder = row.rowRight?.cell?.cellResignFirstResponder() ?? false
		
		return rowLeftResignFirstResponder && rowRightResignFirstResponder
	}
}
