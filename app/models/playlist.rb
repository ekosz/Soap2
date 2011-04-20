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
    @timeleft = 900
    @bathroom = bathroom
  end

  def time_left
    @timeleft
  end

  def run
    @timeleft -= 1
    if @timeleft == 0
      @bathroom.im_done(self)
      #Stop the thread
    else
      sleep 1
    end
  end

end
