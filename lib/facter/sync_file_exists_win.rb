Facter.add(:sync_file_exists_win) do
  confine :kernel => :windows
  setcode do
    File.exist? 'C:\\sumo\\syncsources.json'
  end
end
