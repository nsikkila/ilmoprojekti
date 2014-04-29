#Time::DATE_FORMATS[:laurea_way] = "%m %Y %H.%M"
#Time::DATE_FORMATS[:laurea_way] = lambda { |time| time.strftime("%B #{time.day.ordinalize}") }

Date::DATE_FORMATS[:default] = "%d/%m/%Y"
Time::DATE_FORMATS[:default] = "%d/%m/%Y %H:%M"