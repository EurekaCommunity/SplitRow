//
//  SplitRowCell.swift
//  Valletti
//
//  Created by Marco Betschart on 30.11.17.
//  Copyright © 2017 MANDELKIND. All rights reserved.
//

import Eureka

open class SplitRowCell<L: RowType, R: RowType>: Cell<SplitValues<L.Cell.Value,R.Cell.Value>>, CellType where L: BaseRow, R: BaseRow{
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
		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableViewLeft]|", options: [], metrics: nil, views: ["tableViewLeft": tableViewLeft]))
		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableViewLeft]", options: [], metrics: nil, views: ["tableViewLeft": tableViewLeft]))
		
		contentView.addSubview(tableViewRight)
		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableViewRight]|", options: [], metrics: nil, views: ["tableViewRight": tableViewRight]))
		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[tableViewRight]|", options: [], metrics: nil, views: ["tableViewRight": tableViewRight]))
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	open override func setup(){
		selectionStyle = .none
		setupConstraints()
		
		//ignore Xcode Cast warning here, it works!
		guard let row = self.row as? SplitRow<L,R> else{ return }
		
		tableViewLeft.row = row.rowLeft
		tableViewLeft.setup()
		
		tableViewRight.row = row.rowRight
		tableViewRight.setup()
	}
	
	
	open override func update(){
		tableViewLeft.update()
		tableViewRight.update()
	}
	
	private func setupConstraints(){
		guard let row = self.row as? SplitRow<L,R> else{ return }
		
		contentView.addConstraint(NSLayoutConstraint(item: tableViewLeft, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: row.rowLeftPercentage, constant: 1.0))
		contentView.addConstraint(NSLayoutConstraint(item: tableViewRight, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: row.rowRightPercentage, constant: 1.0))
	}
}
