# Load the rails application
require File.expand_path('../application', __FILE__)

#
# Time formats
#
Time::DATE_FORMATS[:log_time_dy]  = "%d"
Time::DATE_FORMATS[:log_time_mn]  = "%b"
Time::DATE_FORMATS[:log_time_yr]  = "%Y"
Time::DATE_FORMATS[:log_time]     = "%l:%M%P"

# Initialize the rails application
RorWorklog::Application.initialize!
