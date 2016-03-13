#!/usr/bin/env ruby
require 'yaml'
require 'optparse'

puts '|------------------------------|'
puts '|------------------------------|'
puts '|-------- soxbox start --------|'
puts '|------------------------------|'
puts '|------------------------------|'


options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: soxbox.rb [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end.parse!

outputFile = ''

if ARGV.size > 0
    outputFile = ARGV[0]
    p outputFile
end

# current layout of yaml config file is suboptimal
# should update to nested arrays of objects
config = YAML.load_file("box.yaml")
album = config['album']['name']
songs = config['album']['songs'].keys
# TODO: build a tracklist for each song and
# encapsulate remaining logic in a loop over songs
song = songs[0]
tracks = config['album']['songs'][songs[0]].keys

if options[:verbose]
    puts 'mixing up ' + album
    puts '** songs **'
    puts '  - ' + songs.join("\n  - ")
    puts '** tracks **'
    puts '  - ' + tracks.join("\n  - ")
end
puts '** build file list **'

files = []
tracks.each do |track|
    trackFiles= config['album']['songs'][song][track]
    addFile = trackFiles[rand(trackFiles.length)]
    puts track + ' @ ' + addFile
    files << addFile
end

puts '** files **'
puts files.join("\n")

puts '** build command **'
command = 'sox'
files.each do |file|
    command += ' '
    if !(files.index(file) == 0)
        command += '-m '
    end
    command += file
end

command += ' ../' + (outputFile != '' ? outputFile : 'output.wav')

puts '$ ' + command

exec ('cd input && ' + command)

puts '|-------- soxbox end --------|'

#puts 'files' + files
