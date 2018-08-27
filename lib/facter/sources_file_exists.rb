Facter.add(:sources_file_exists) do
  confine :kernel => :linux
  setcode do
    File.exist? '/usr/local/sumo/sources.json'
  end
end
