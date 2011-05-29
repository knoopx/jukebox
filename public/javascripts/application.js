soundManager.url = '/swf/';
soundManager.flashVersion = 9;
soundManager.useFlashBlock = false;
// soundManager.useHTML5Audio = true;
//soundManager.useConsole = true;
//soundManager.debugMode = true;

AudioPlayer = {
    init: function() {
        this.initUI();
    },

    initUI: function() {
        this.container = $("<div/>", {id: "player"});
        this.container.hide();

        this.information = $("<div/>", {id: "info"});
        this.information.appendTo(this.container);

        this.artistName = $("<span/>", {"class": "artist"});
        this.artistName.text("Unknown Artist");
        this.artistName.appendTo(this.information);

        this.trackTitle = $("<span/>", {"class": "track"});
        this.trackTitle.text("Unknown Track");
        this.trackTitle.appendTo(this.information);

        this.progressBar = $("<div/>", { id: "progress-bar", height: "10px"});
        this.progressBar.css({"position": "relative"});
        this.progressBar.appendTo(this.container);

        this.seekBar = $("<div/>", { id: "seek-bar", height: "10px", width: "100%" });
        this.seekBar.click(function(e) {
            AudioPlayer.currentStream.setPosition(e.offsetX / $(this).width() * AudioPlayer.currentStream.duration);
            e.preventDefault();
        });
        this.seekBar.appendTo(this.progressBar);

        this.bufferBar = $("<div/>", { id: "buffer-bar", height: "10px", width: "0%" });
        this.bufferBar.appendTo(this.seekBar);

        this.timeBar = $("<div/>", { id: "time-bar", height: "10px", width: "0%" });
        this.timeBar.appendTo(this.seekBar);

        this.buttons = $("<div/>", {"class": "buttons"});

        this.playButton = $("<a/>", {"class": "button play", href: "#"});
        this.playButton.text("Play");
        this.playButton.click(this.togglePlay);
        this.playButton.appendTo(this.buttons);

        this.skipButton = $("<a/>", {"class": "button skip"});
        this.skipButton.text("Skip");
        this.skipButton.click(this.skipTrack);
        this.skipButton.appendTo(this.buttons);

        this.buttons.appendTo(this.container);

        $("body").append(this.container);
    },

    playTrack: function(trackId) {
        soundManager.stopAll();

        this.getTrack(trackId, function(track) {
            soundManager.destroySound(track.id);

            $(".track").removeClass("playing");
            $("#track_" + track.id).addClass("playing");
            AudioPlayer.currentTrack = track;
            AudioPlayer.artistName.text(track.artist);
            AudioPlayer.trackTitle.text(track.title);
            AudioPlayer.container.show();

            AudioPlayer.currentStream = soundManager.createSound({
                id: track.id,
                url: "/tracks/" + track.id + "/stream",
                onplay: AudioPlayer.resumePlayback,
                onresume: AudioPlayer.resumePlayback,
                onpause: AudioPlayer.stopPlayback,
                onstop: AudioPlayer.stopPlayback,
                whileloading: AudioPlayer.updateLoadProgress,
                whileplaying: AudioPlayer.updatePosition,
                onfinish: AudioPlayer.skipTrack
            });

            soundManager.play(track.id);
        });
    },
    playTracks: function(trackIds) {
        this.setMode("playlist");
        this.playlist = trackIds;
        this.playTrack(this.playlist[0]);
    },
    getTrack: function(trackId, callback) {
        $.getJSON("/tracks/" + trackId, function(track) {
            callback(track);
        });
    },
    resumePlayback: function() {
        AudioPlayer.playButton.text("Pause");
    },
    stopPlayback: function() {
        AudioPlayer.playButton.text("Play");
    },
    updatePosition: function() {
        AudioPlayer.timeBar.width((this.position / this.duration * 100) + "%");

    },
    togglePlay: function(e) {
        soundManager.togglePause(AudioPlayer.currentTrack.id);
        e.preventDefault();
    },
    updateLoadProgress: function() {
        AudioPlayer.bufferBar.width((this.bytesLoaded / this.bytesTotal * 100) + "%");
    },
    setMode: function(mode) {
        switch (mode) {
            case "playlist": {
                AudioPlayer.mode = "playlist";
//                this.skipButton.hide();
                return
            }
            case "endless": {
                AudioPlayer.mode = "endless";
//                this.skipButton.show();
            }
        }
    },
    skipTrack: function() {
        switch (AudioPlayer.mode) {
            case "playlist": {
                var index = $(AudioPlayer.playlist).index(AudioPlayer.currentTrack.id);
                var nextIndex = index + 1;
                if (nextIndex < AudioPlayer.playlist.length) {
                    AudioPlayer.playTrack(AudioPlayer.playlist[nextIndex])
                }
                return
            }
            case "endless": {
                //TODO
            }
        }
    }
};

soundManager.onready(function() {
    AudioPlayer.init();
});
