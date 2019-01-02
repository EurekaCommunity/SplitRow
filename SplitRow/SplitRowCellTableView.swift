//
//  SplitRowCellTableView.swift
//  Valletti
//
//  Created by Marco Betschart on 02.12.17.
//  Copyright © 2017 MANDELKIND. All rights reserved.
//

import Eureka

class SplitRowCellTableView<T: TypedRowType>: UITableView, UITableViewDelegate, UITableViewDataSource{

	var row: T?
	
	var leftSeparatorStyle: UITableViewCell.SeparatorStyle = .none{
		didSet{
			if oldValue != self.leftSeparatorStyle{
				self.reloadData()
			}
		}
	}
	
	override init(frame: CGRect, style: UITableView.Style) {
		super.init(frame: frame, style: style)

		self.dataSource = self
		self.delegate = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	open func setup(){
		guard let row = self.row else{ return }
		row.baseCell.setup()
		row.baseCell.selectionStyle = .none
	}
	
	open func update(){
		guard let row = self.row else{ return }
		row.updateCell()
		row.baseCell.selectionStyle = .none
	}
	
	
	// MARK: UITableViewDelegate
	
	open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let row = self.row else{ return }
		
		// row.baseCell.cellBecomeFirstResponder() may be cause InlineRow collapsed then section count will be changed. Use orignal indexPath will out of  section's bounds.
		if !row.baseCell.cellCanBecomeFirstResponder() || !row.baseCell.cellBecomeFirstResponder() {
			tableView.endEditing(true)
		}
		row.didSelect()
	}
	
	open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let row = self.row else{ return tableView.rowHeight }
		return row.baseCell.height?() ?? tableView.rowHeight
	}
	
	open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let row = self.row else{ return tableView.rowHeight }
		return row.baseCell.height?() ?? tableView.estimatedRowHeight
	}
	
	open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return false
	}
	
	
	// MARK: UITableViewDataSource
	
	open func numberOfSections(in tableView: UITableView) -> Int {
		return self.row == nil ? 0 : 1
	}
	
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.row == nil ? 0 : 1
	}
	
	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let row = self.row else{ fatalError() }
		
		if let cell = row.baseCell, leftSeparatorStyle == .singleLine, false == cell.subviews.contains(where: { $0.backgroundColor == .groupTableViewBackground }){
			let separatorView = UIView()
			separatorView.backgroundColor = .groupTableViewBackground
			separatorView.translatesAutoresizingMaskIntoConstraints = false

			cell.addSubview(separatorView)
			cell.bringSubviewToFront(separatorView)
			
			cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separatorView(1)]", options: [], metrics: nil, views: ["separatorView":separatorView]))
			cell.addConstraint(NSLayoutConstraint(item: separatorView, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: 11.0))
			cell.addConstraint(NSLayoutConstraint(item: separatorView, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottom, multiplier: 1.0, constant: -11.0))
		}
		
		return row.baseCell
	}
}
