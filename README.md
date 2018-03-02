# SplitRow
A row for Eureka to put two rows side by side into the same UITableViewCell.

<p align="left">
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift4-compatible-4BC51D.svg?style=flat" alt="Swift 4 compatible" /></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
<a href="https://raw.githubusercontent.com/EurekaCommunity/SplitRow/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

By [MANDELKIND](http://mandelkind.swiss).

## Contents
 * [Introduction](#introduction)
 * [Usage](#usage)
 * [Requirements](#requirements)
 * [Getting involved](#getting-involved)

## Introduction

`SplitRow` is a custom row for Eureka designed to put two rows side by side into the same UITableViewCell.

<img src="Media/SplitRow.jpg" width="450"/>

## Usage

```swift
import SplitRow

class ViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section()
            <<< SplitRow<PushRow<String>,TextRow>(){
		            $0.rowLeft = PushRow<String>(){
            			$0.selectorTitle = "E-Mail"
            			$0.options = ["Private","Work","Others"]
            		}
					
            		$0.rowRight = TextRow(){
            			$0.placeholder = "E-Mail"
            		}
				
        	}.onChange{
        		print("SplitRow.onChange:","left:",$0.value?.left,"right:",$0.value?.right)
        	}
    }
}
```

## Requirements

* iOS 9.0+
* Xcode 9.0+
* Eureka ~> 4.1

## Getting involved

* If you **want to contribute** please feel free to **submit pull requests**.
* If you **have a feature request** please **open an issue**.

## Author

* [Marco Betschart](https://github.com/marbetschar)
