# Bathrooms act as an observer to all of the playlists in its room.
# It is in charge of handing out info about its queue / current playlist
# and starting new palylist as the old ones die.

class Bathroom
  # It has a queue for managing the playlists.
  # This queue can be accessed from outside the class,
  # but only in a read format.
  attr_reader :queue

  # `Bathroom.new` takes `name` and `number`.
  # The `number` is the alsa devise number.
  # This should be set in the `config/bathroom.config` file.
  def initailze(name, number)
    @queue = []
    @current_playlist = nil
    @number = number
    @name = name
  end

  #### Public Interface

  # `Bathroom#create_playlist` a `name` which is the name of the
  # user creating the playlist, `songs` which is a hash, and `url` which is
  # the url of the stream of music.
  #
  # The hash of songs will look something like
  #
  #     [
  #       {:name=>"Piano Man",
  #        :artist=>"Billy Joel",
  #        :length=>170 #Length of song in seconds
  #       },
  #       ...
  #     ]
  #
  # This data will be ripped from the music files client side
  #
  # After it creates the playlist is automatically adds it to its internal
  # queue.
  def create_playlist(user, songs, url)
    add_to_queue(Playlist.new(user, songs, url, self))
  end

  # `Bathroom#im_done` is called by its playlists as they finish
  # there songs.  This will happen after 15mins or if the lengths
  # of the songs are known, then it will stop after all the music
  # has finished.
  #
  # The method stops the current `mplayer` process, then plays the next
  # playlist in the queue, if there is one
  def im_done(playlist)
    #Stop the playlist
    Process.kill @music_pid
    #Grab and play the next playist, if there is one
    @current_playlist = @queue.shift and play @current_playlist 
  end

  #### Private Interface

  private

  # `Bathroom#add_to_queue` adds playlists to its internal queue, but also
  # plays the same playlist, if there is no playlist playing at the moment.  
  # If that is the case, then the queue will still be empty after the method
  # is run.
  def add_to_queue(playlist)
    @queue << playlist
    if @current_playlist.nil? 
      @current_playlist = @queue.shift
      play @current_playlist
    end
  end

  # `Bathroom#play` takes a playlist and starts a `mplayer` process pointing
  # to that playlist's url.  It also tells the playlist to start its own
  # Thread, which so far is only the countdown.
  def play(playlist)
    playlist.run
    @music_pid = fork do
      exec "mplayer", "-cache", "1024", "-really-quiet", "-noconsolecontrols", 
      "-ao", "alsa:device=hw=#{@number}.0", playlist.url 
    end
  end

end
