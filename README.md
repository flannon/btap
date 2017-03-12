###Better than a PostIt

The impetus for this project came when I saw this photo of Mark Zuckerberg in which it's clearly vissbile that he's taped over his camera and microphone jack.  When I saw this image I immediatly thought three things.

  1. With the resources at his disposal shouldn't Zuckerberg have assigned someone the task of writing a utility that he could use to easily control his camera and microphone?
  2. Tape on the microphone jack?  Really?  What's that supposed to accomplish?
  3. I should have a better method for securing my camera than simply covering it with a postit.

btap.sh is the result of these questions. It's not perfect, but it is better than a PostIt for securiing your workstations camera and microphone.  btap.sh has a the following features.

  * Sets system microphone input levels to zero.  This isn't perfect, but for a quick and dirty solution it gets the job done.  For future versions I want actually disable adio input.
  * Disables the quicktime video driver.
  * Kills any processes that are currently using the video driver
  * Loads a lauchd script to monitor the video and audio input state and disable them again should another process enable input.
  * Logging <needs descripton>
  * Self install feature will install btap.sh in /usr/local/bin and make it availabe as btap.  Requires that you yave /usr/local/bin in our $PATH.
  * Reenables audio and video with
 
    $ btap -r | btap --rolling
