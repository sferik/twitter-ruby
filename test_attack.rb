class timing_attack
    # ruleid: timing-attack
    http_basic_authenticate_with name: "Luna", password: "OnlyCuteAnimals22"
    # ruleid: timing-attack
    http_basic_authenticate_with :name => ENV["NAME"], :password => ENV["PASSWORD"]
  end