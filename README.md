audiosetdl
================
Modules and scripts for downloading Google's
[AudioSet](https://research.google.com/audioset/) dataset, a dataset of
~2.1 million annotated segments from YouTube videos.



## Setup
* Clone the repository onto your machine.


* If you would like to get started right away with a standalone
  [(mini)conda](https://conda.io/miniconda.html), environment, run `setup.sh`
  in the project directory. This will install a local Anaconda environment in
  `<PROJECT DIR>/bin/miniconda`. You can find a `python` executable at
  `<PROJECT DIR>/bin/miniconda/bin/python`.
  * Example: `./setup.sh`
  
* If you would like to work with your existing working environment, it should
  satisfy the following requirements:
  * [Python 3](https://www.python.org/downloads/) and dependencies
    * On Mac, can be installed with `brew install python3`
    * On Ubuntu/Debian, can be installed with `apt-get install python3`
    * Dependencies can be installed with
      `pip install -r <PROJECT DIR>/requirements.txt`
  * [`ffmpeg`](https://www.ffmpeg.org/)
    * On Mac, can be installed with `brew install ffmpeg`
    * On Ubuntu/Debian, can be installed with `apt-get install ffmpeg`
  * [`sox`](http://sox.sourceforge.net/)
    * On Mac, can be installed with `brew install sox`
    * On Ubuntu/Debian, can be installed with `apt-get install sox`
   

## Running

### As a single script
* Run `python download_audioset.py`
    * If you are using the local standalone `conda` installation, either
      activate the conda virtual environment, or use the python executable found
      in the local conda installation.
    * The script will automatically download the scripts into your data
      directory if they do not exist and then start downloading the audio and
      video for all of the segments in parallel.
    * You can tweak how the downloading and processing is done. For example,
        * URL/path to dataset subset files
        * Audio/video format and codec
        * Different strategies for obtaining video
        * Number of multiprocessing pool workers used
        * Path to logging
    * Run `python download_audioset.py -h` for a full list of arguments

### SLURM
This can be run as a batch of SLURM jobs

* Run `download_subset_files.sh`
  * Sets up the data directory structure in the given folder (which will be
    created) and downloads the AudioSet subset files to that directory.
    If the `--split <N>` option is used, the script splits the files into N
    parts, which will have a suffix for a job ID, e.g. `eval_segments.csv.01`.
  * Example: `./download_subset_files.sh --split 10 /home/user/audiosetdl/data`

* Use `sbatch` to run the `audiosetdl-job-array.s` job array script
  * SLURM job array script that can be run by sbatch. Be sure to edit this to
    change the
    location of the repository (`$SRCDIR`) and to set the data directory
    (`$DATADIR`). Update any other configurations, such as email notifications
    and memory usage as it fits your use case.
  * Example: `sbatch --array=1-10 audiosetdl-job-array.s`
  
  
## Examples
Examples can be found in the `notebooks` directory of this repository.


## Cases where videos cannot be downloaded
* Video removed
* User account deleted
* Not available in country
* Need to sign in to view
* Video no longer exists
* Copyright takedown

## Notes by David
Easiest way to do this is install sox via brew.
* Download ffmpeg and ffprobe https://ffmpeg.org/download.html#build-mac
* Change filenames in setup.sh to be MacOSX instead of Linux.
* comment out lines that download ffmpeg
* Copy ffmpeg and ffprobe binaries into <PROJECT_DIR>/bin/ffmpeg/

#
### Install homebrew 
 /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

### Install wget and audiosetdl
 brew install wget

 ./setup.sh

### Install sox
 brew install sox --with-flac --with-lame --with-libao --with-libsndfile --with-libvorbis --with-opencore-amr --with-opusfile

* move old sox out of the way and symlink brew's sox to miniconda's bin
 ln -s /usr/local/bin/sox <PROJECT_DIR>/bin/miniconda/bin/

 utils.run_comand() needs to open POPEN with universal_newlines=True to enable string format otherwise json module will fail.

Youtube is mostly AAC format so it's not necessary to store in any higher quality format, but sox doesn't support AAC. Easiest compressed format to use with sox is flac. Maybe ogg or mp3 will work also.
