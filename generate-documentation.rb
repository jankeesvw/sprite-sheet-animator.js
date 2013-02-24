require 'rocco'

File.open('index.html', 'w') do |f| 
  rocco_html_output = Rocco.new('lib/sprite-sheet-animator.coffee').to_html
  f.write(rocco_html_output) 
end