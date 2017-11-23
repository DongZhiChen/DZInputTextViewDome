Pod::Spec.new do |s|
s.name         = 'DZInputTextView'
s.version      = '1.0.4'
s.summary      = 'text input view'
s.homepage     = 'https://github.com/DongZhiChen/DZInputTextViewDome'
s.license= { :type => "MIT", :file => "LICENSE" }
s.authors      = {'ChenDongZhi' => '644495218@qq.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/DongZhiChen/DZInputTextViewDome.git', :tag => s.version}
s.source_files ='DZInputTextView/*.{h,m}'
s.requires_arc = true
s.framework  = 'UIKit'
s.dependency 'Masonry'
end
