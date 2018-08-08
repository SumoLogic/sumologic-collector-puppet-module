Facter.add(:service_file_exists) do
  confine :kernel => :linux
  setcode do
    if File.exist? "/opt/SumoCollector/collector"
      result = true
      result
    else
      result = false
      result
    end
  end
end
