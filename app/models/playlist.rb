###
# This class reprecents one users request to play music in a bathroom
# It is in charge of counting down its timer, and notifing its bathroom
# When it is finished playing
###

class Playlist
  attr_reader :songs, :url, :user

  def initialize(user, songs, url, bathroom)
    @user = user
    @songs = songs 
    @url = url
    # The timeout is currenly hardcoded, but could be loaded for a 
    # config file in the future.
    @timeleft = 900
    @bathroom = bathroom
    @this = self
  end

  #### Public Interface

  # `Playlist#time_left` returns the time left until its end in secounds.  This
  # can be changed in the future to return a easier to read string format.
  def time_left
    @timeleft
  end


  # `Playlist#run` starts the playlist thread.  So far all it does is decrement
  # the timeout, and once it reaches it, stops the thread and notifies its
  # bathroom that it has finished.
  def run
    Thread.new do
      loop do
        @timeleft -= 1
        if @timeleft <= 0
          @bathroom.im_done(@this)
          #Stop the thread
          self.exit
        else
          sleep 1 #Wait for 1 sec
        end
      end
    end
  end

end
