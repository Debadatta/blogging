# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Blogging::Application.initialize!
module Config
 APPLICATION_ROOT = '/var/www/html'
 IMAGE_ROOT = '/home/myuser/www/InstantXbox/public/images'
 STATUS = Hash.new
 STATUS["Active"] = 1
 STATUS["Inactive"] = 2
 COUNTER = Hash.new
 COUNTER[1] = 1
 COUNTER[2] = 2
 COUNTER[3] = 3
 COUNTER[4] = 4
 COUNTER[5] = 5
 COUNTER[6] = 6
 COUNTER[7] = 7
 COUNTER[8] = 8
 COUNTER[9] = 9
 COUNTER[10] = 10
end

