Pod::Spec.new do |s|
s.name         = "SplitRow"
s.version      = "2.3.0"
s.summary      = "A row for Eureka to put two rows side by side into the same UITableViewCell."
s.homepage     = "https://github.com/EurekaCommunity/SplitRow"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.authors      = { "Marco Betschart" => "github@marco.betschart.name", "Kate Mercer" => "kate.mercer@sas.com" }
s.social_media_url   = "https://twitter.com/EurekaCommunity"
s.platform     = :ios, "9.3"
s.source       = { :git => "https://github.com/EurekaCommunity/SplitRow.git", :tag => "#{s.version}" }
s.source_files  = "SplitRow/**/*.{swift}"
s.frameworks = "UIKit", "Foundation"
s.requires_arc = true
s.swift_version = "5.0"
s.dependency "Eureka", "~> 5.3.5"
end
