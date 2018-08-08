Facter.add(:sync_file_exists) do
  confine :kernel => :linux
  setcode do
    if File.exist? "/usr/local/sumo/syncsources.json"
      result = true
      result
    else
      result = false
      result
    end
  end
end
