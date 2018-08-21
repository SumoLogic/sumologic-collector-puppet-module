Facter.add(:sources_file_exists_win) do
  confine :kernel => :windows
  setcode do
    File.exist? 'C:\\sumo\\sources.json'
  end
end
