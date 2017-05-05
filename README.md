##Better than a PostIt

The impetus for this script came when I saw this photo of Mark Zuckerberg in which it's clearly visibile that he's taped over his camera and microphone jack.  When I saw this image I immediatly thought three things.

  1. With the resources at his disposal, shouldn't Zuckerberg have assigned someone the task of writing a utility to easily control his camera and microphone?
  2. Tape on the microphone jack?  Really?  What's that all about?
  3. I should have a better method for securing my camera than simply covering it with a postit.

btap.sh is the result of these questions. It's not perfect, but it is better than a PostIt for securiing your workstation's camera and microphone.  

### btap features

  * When run as a normal user it kills video processes owned by the user and sets audio input levels to 0.

    $ btap

  *  When run as root it also starts a lauchd job that monitors the video droivers and audio levels.  Should they become re-enabled it will re-run btap.
      
    $ sudo btap

  * To re-enable audio and video functionality run btap with the -a flag.  This will unload the launchd job, re-enable the video drivers, and set audio input levels to 100.

    $ sudo btap -a

  * Sets system microphone input levels to zero.  This isn't perfect, but for a quick and dirty solution it gets the job done.  For future versions I want actually disable adio input.
  * Disables the quicktime video driver.
  * Kills any processes that are currently using the video driver
  * Loads a lauchd script to monitor the video and audio input state and disable them again should another process enable input.
  * Logging <needs descripton>
  * Reenables audio and video with the -a flag.
 
    $ btap 

    $ btap -a 

    $ btap -v
      * verbose mode for debuggin 

### Installation

To install btap run the configure script.

    $ ./configure
    
