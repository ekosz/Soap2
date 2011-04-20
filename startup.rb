###
# This file is only run once, when the system is first
# Being restarted.  It creates the bathroom globals
# from the config file
####

bath_txt = YAML.load File.read 'config/bathrooms.config'

bath_txt.each do |room|
  # Eval is Evil, unless you know what you're doing
  eval "#{room[:name].capitalize} = Bathroom.new(#{room[:number]})"
end
