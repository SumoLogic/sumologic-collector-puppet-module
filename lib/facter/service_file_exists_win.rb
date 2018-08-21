Facter.add(:service_file_exists_win) do
  confine :kernel => :windows
  setcode do
    File.exist? 'C:\\Program Files (x86)\\Sumo Logic Collector\\collector.bat'
  end
end
