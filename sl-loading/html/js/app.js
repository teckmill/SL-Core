// Loading Screen Manager
class LoadingScreen {
    constructor() {
        this.config = window.Config;
        this.progress = 0;
        this.currentTip = 0;
        this.currentTrack = 0;
        this.isPlaying = false;
        
        this.initializeElements();
        this.setupEventListeners();
        this.initializeScreen();
    }

    initializeElements() {
        // Background
        this.backgroundContainer = document.getElementById('background-container');
        this.backgroundOverlay = document.getElementById('background-overlay');

        // Progress Elements
        this.progressBar = document.getElementById('progress-fill');
        this.progressCircle = document.getElementById('progress-circle');
        this.progressDots = document.getElementById('progress-dots');
        this.loadingMessage = document.getElementById('loading-message');

        // Tips
        this.tipText = document.getElementById('tip-text');

        // Server Info
        this.discordLink = document.getElementById('discord-link');
        this.websiteLink = document.getElementById('website-link');

        // Music Player
        this.musicToggle = document.getElementById('music-toggle');
        this.trackName = document.getElementById('track-name');
        this.volumeSlider = document.querySelector('#volume-slider input');
        this.audio = new Audio();
    }

    setupEventListeners() {
        // Music Controls
        this.musicToggle.addEventListener('click', () => this.toggleMusic());
        this.volumeSlider.addEventListener('input', (e) => this.setVolume(e.target.value));
        this.audio.addEventListener('ended', () => this.playNextTrack());

        // Loading Events
        window.addEventListener('message', (event) => {
            const data = event.data;
            
            switch(data.type) {
                case 'updateProgress':
                    this.updateProgress(data.progress);
                    break;
                case 'setMessage':
                    this.setLoadingMessage(data.message);
                    break;
                case 'shutdown':
                    this.shutdown();
                    break;
            }
        });
    }

    initializeScreen() {
        // Set Background
        this.setupBackground();

        // Initialize Progress Display
        this.setupProgressDisplay();

        // Start Tips Rotation
        if (this.config.EnableTips) {
            this.startTipsRotation();
        }

        // Setup Server Info
        this.setupServerInfo();

        // Initialize Music
        if (this.config.EnableMusic) {
            this.initializeMusic();
        }

        // Apply Theme
        this.applyTheme();
    }

    setupBackground() {
        switch(this.config.BackgroundType) {
            case 'slideshow':
                this.startSlideshow();
                break;
            case 'video':
                this.setupVideo();
                break;
            case 'image':
                this.setBackgroundImage(this.config.BackgroundImages[0]);
                break;
        }
    }

    startSlideshow() {
        let currentSlide = 0;
        this.setBackgroundImage(this.config.BackgroundImages[currentSlide]);

        setInterval(() => {
            currentSlide = (currentSlide + 1) % this.config.BackgroundImages.length;
            this.setBackgroundImage(this.config.BackgroundImages[currentSlide]);
        }, this.config.SlideshowDuration);
    }

    setBackgroundImage(imagePath) {
        this.backgroundContainer.style.backgroundImage = `url(${imagePath})`;
        this.backgroundContainer.style.backgroundSize = 'cover';
        this.backgroundContainer.style.backgroundPosition = 'center';
    }

    setupVideo() {
        const video = document.createElement('video');
        video.src = this.config.BackgroundVideo;
        video.autoplay = true;
        video.loop = true;
        video.muted = true;
        video.style.position = 'absolute';
        video.style.width = '100%';
        video.style.height = '100%';
        video.style.objectFit = 'cover';
        
        this.backgroundContainer.appendChild(video);
    }

    setupProgressDisplay() {
        const elements = {
            bar: this.progressBar,
            circle: this.progressCircle,
            dots: this.progressDots
        };

        // Hide all progress elements
        Object.values(elements).forEach(el => el.style.display = 'none');

        // Show selected progress type
        elements[this.config.ProgressType].style.display = 'block';
    }

    updateProgress(progress) {
        this.progress = progress;
        
        switch(this.config.ProgressType) {
            case 'bar':
                this.progressBar.style.width = `${progress}%`;
                break;
            case 'circle':
                // Update circle animation if needed
                break;
            case 'dots':
                // Update dots animation if needed
                break;
        }

        // Update loading message
        const messageIndex = Math.floor(progress / (100 / this.config.ProgressMessages.length));
        if (messageIndex < this.config.ProgressMessages.length) {
            this.setLoadingMessage(this.config.ProgressMessages[messageIndex]);
        }
    }

    setLoadingMessage(message) {
        this.loadingMessage.textContent = message;
    }

    startTipsRotation() {
        this.showTip(this.currentTip);
        
        setInterval(() => {
            this.currentTip = (this.currentTip + 1) % this.config.Tips.length;
            this.showTip(this.currentTip);
        }, this.config.TipInterval);
    }

    showTip(index) {
        this.tipText.textContent = this.config.Tips[index];
    }

    setupServerInfo() {
        this.discordLink.href = this.config.DiscordLink;
        this.websiteLink.href = this.config.WebsiteLink;
    }

    initializeMusic() {
        if (this.config.MusicTracks.length > 0) {
            if (this.config.ShuffleTracks) {
                this.shuffleTracks();
            }
            
            this.setVolume(this.config.MusicVolume * 100);
            this.loadTrack(0);
        }
    }

    shuffleTracks() {
        for (let i = this.config.MusicTracks.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [this.config.MusicTracks[i], this.config.MusicTracks[j]] = 
            [this.config.MusicTracks[j], this.config.MusicTracks[i]];
        }
    }

    loadTrack(index) {
        const track = this.config.MusicTracks[index];
        this.audio.src = track.file;
        this.trackName.textContent = track.name;
        
        if (this.isPlaying) {
            this.audio.play();
        }
    }

    toggleMusic() {
        this.isPlaying = !this.isPlaying;
        
        if (this.isPlaying) {
            this.audio.play();
            this.musicToggle.classList.add('playing');
        } else {
            this.audio.pause();
            this.musicToggle.classList.remove('playing');
        }
    }

    setVolume(value) {
        const volume = value / 100;
        this.audio.volume = volume;
        this.volumeSlider.value = value;
    }

    playNextTrack() {
        this.currentTrack = (this.currentTrack + 1) % this.config.MusicTracks.length;
        this.loadTrack(this.currentTrack);
    }

    applyTheme() {
        document.documentElement.style.setProperty('--color-primary', this.config.Theme.Primary);
        document.documentElement.style.setProperty('--color-secondary', this.config.Theme.Secondary);
        document.documentElement.style.setProperty('--color-background', this.config.Theme.Background);
        document.documentElement.style.setProperty('--color-text', this.config.Theme.Text);
        document.documentElement.style.setProperty('--color-text-secondary', this.config.Theme.TextSecondary);
        document.documentElement.style.setProperty('--animation-duration', `${this.config.AnimationDuration}ms`);
    }

    shutdown() {
        // Fade out animation
        document.body.style.opacity = 0;
        setTimeout(() => {
            // Send shutdown complete message to client
            fetch('https://sl-loading/shutdownComplete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({})
            });
        }, this.config.AnimationDuration);
    }
}

// Initialize Loading Screen
window.onload = () => {
    const loadingScreen = new LoadingScreen();
};
