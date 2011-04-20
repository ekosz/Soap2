####
# This class acts as an observer to all of the playlists in its room
# It is in charge of handing out info about its queue / current playlist
# And starting new palylist as the old ones die
####

class Bathroom
  attr_reader :queue

  def initailze(number)
    @queue = []
    @current_playlist = nil
    @number = number
  end

  def create_playlist(user, songs, url)
    add_to_queue(Playlist.new(user, songs, url, self))
  end

  def im_done(playlist)
    #Stop the playlist if needed
    #Grab and play the next playist, if there is one
    @current_playlist = @queue.shift and play @current_playlist 
  end

  private

  def add_to_queue(playlist)
    @queue << playlist
    if @current_playlist.nil? 
      @current_playlist = @queue.shift
      play @current_playlist
    end
    # Other stuff goes here
  end

  def play(playlist)
    playlist.run
    exec "mplayer", "-cache", "1024", "-really-quiet", "-noconsolecontrols", 
      "-ao", "alsa:device=hw=#{@number}.0", playlist.url 
  end

end
