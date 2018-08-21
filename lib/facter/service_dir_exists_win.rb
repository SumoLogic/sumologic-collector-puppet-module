Facter.add(:sources_dir_exists_win) do
  confine :kernel => :windows
  setcode do
    File.directory? 'C:\\sumo' && !Dir.glob('C:\\sumo\\*.json').empty?
  end
end
