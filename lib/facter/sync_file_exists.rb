Facter.add(:sync_file_exists) do
  confine :kernel => :linux
  setcode do
    File.exist? '/usr/local/sumo/syncsources.json'
  end
end
