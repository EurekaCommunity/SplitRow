//
//  ViewController.swift
//  Example
//
//  Created by Marco Betschart on 08.12.17.
//  Copyright © 2017 MANDELKIND. All rights reserved.
//

import Eureka
import SplitRow
import PostalAddressRow

class ViewController: FormViewController{

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "SplitRow Examples"
		
		form +++ Section("Phone")
			<<< SplitRow<PushRow<String>,PhoneRow>(){
				$0.rowLeft = PushRow<String>(){
					$0.options = ["work","private","other"]
				}
				
				$0.rowRight = PhoneRow(){
					$0.placeholder = "Phone"
				
				}.cellUpdate{ cell, row in
					cell.textField?.clearButtonMode = .whileEditing
					cell.textField?.textAlignment = .right
				}
		}
		
		form +++ Section("E-Mail")
			<<< SplitRow<PushRow<String>,EmailRow>(){
				$0.rowLeft = PushRow<String>(){
					$0.options = ["work","private","other"]
				}
				
				$0.rowRight = EmailRow(){
					$0.placeholder = "E-Mail"
				
				}.cellUpdate{ cell, row in
					cell.textField?.clearButtonMode = .whileEditing
					cell.textField?.textAlignment = .right
				}
		}
		
		form +++ Section("URL")
			<<< SplitRow<PushRow<String>,URLRow>(){
				$0.rowLeft = PushRow<String>(){
					$0.options = ["work","private","other"]
				}
				
				$0.rowRight = URLRow(){
					$0.placeholder = "URL"
				
				}.cellUpdate{ cell, row in
					cell.textField?.clearButtonMode = .whileEditing
					cell.textField?.textAlignment = .right
				}
		}
		
		form +++ Section("Address")
			<<< SplitRow<PushRow<String>,PostalAddressRow>(){
				$0.rowLeft = PushRow<String>(){
					$0.options = ["work","private","other"]
				}
				
				$0.rowRight = PostalAddressRow(){
					$0.streetPlaceholder = "Street"
					$0.statePlaceholder = "State"
					$0.cityPlaceholder = "City"
					$0.postalCodePlaceholder = "ZIP"
					$0.countryPlaceholder = "Country"
				}
			}
		
		form +++ MultivaluedSection(multivaluedOptions: [.Insert,.Delete,.Reorder], header: "URLs", footer: ""){
			$0.multivaluedRowToInsertAt = { _ in
				return SplitRow<PushRow<String>,URLRow>(){
					$0.rowLeft = PushRow<String>(){
						$0.options = ["work","private","other"]
					}
					
					$0.rowRight = URLRow(){
						$0.placeholder = "URL"
						
						}.cellUpdate{ cell, row in
							cell.textField?.clearButtonMode = .whileEditing
							cell.textField?.textAlignment = .right
					}
				}
			}
			guard let row = $0.multivaluedRowToInsertAt?(0) else{ return }
			$0 <<< row
		}
		
		form +++ MultivaluedSection(multivaluedOptions: [.Insert,.Delete,.Reorder], header: "Addresses", footer: ""){
			$0.multivaluedRowToInsertAt = { _ in
				return SplitRow<PushRow<String>,PostalAddressRow>(){
					$0.rowLeft = PushRow<String>(){
						$0.options = ["work","private","other"]
					}
					
					$0.rowRight = PostalAddressRow(){
						$0.streetPlaceholder = "Street"
						$0.statePlaceholder = "State"
						$0.cityPlaceholder = "City"
						$0.postalCodePlaceholder = "ZIP"
						$0.countryPlaceholder = "Country"
					}
				}
			}
			
			guard let row = $0.multivaluedRowToInsertAt?(0) else{ return }
			$0 <<< row
		}
	}
}
