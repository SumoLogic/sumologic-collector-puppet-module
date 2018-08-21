Facter.add(:service_file_exists) do
  confine :kernel => :linux
  setcode do
    File.exist? '/opt/SumoCollector/collector'
  end
end
