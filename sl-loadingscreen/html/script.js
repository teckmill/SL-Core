const tips = [
    "Press 'F1' to open the help menu",
    "Join our Discord for the latest updates and support",
    "Use '/report' to report any issues to staff",
    "Check out our website for server rules and guides",
    "Press 'K' to access your inventory",
    "Use 'T' to open the chat",
    "Press 'F3' to open your phone",
    "Join our community events for exclusive rewards",
    "Remember to read the server rules",
    "Need help? Our staff team is here to assist you"
];

let currentTip = 0;
let progress = 0;
const music = document.getElementById('music');
const toggleMusicBtn = document.getElementById('toggleMusic');
const skipTrackBtn = document.getElementById('skipTrack');
const loadingBar = document.getElementById('loadingBar');
const statusText = document.getElementById('status');
const tipsElement = document.getElementById('tips');

// Music playlist
const playlist = [
    'music/track1.mp3',
    'music/track2.mp3',
    'music/track3.mp3'
];
let currentTrack = 0;

// Initialize loading screen
window.addEventListener('load', () => {
    updateTip();
    setInterval(updateTip, 5000);
    simulateLoading();
    initializeMusic();
});

// Handle music controls
toggleMusicBtn.addEventListener('click', () => {
    if (music.paused) {
        music.play();
        toggleMusicBtn.innerHTML = '<i class="fas fa-volume-up"></i>';
    } else {
        music.pause();
        toggleMusicBtn.innerHTML = '<i class="fas fa-volume-mute"></i>';
    }
});

skipTrackBtn.addEventListener('click', () => {
    currentTrack = (currentTrack + 1) % playlist.length;
    music.src = playlist[currentTrack];
    music.play();
});

// Skip intro with spacebar
document.addEventListener('keydown', (e) => {
    if (e.code === 'Space') {
        progress = 100;
        updateLoadingBar();
    }
});

// Simulate loading progress
function simulateLoading() {
    if (progress < 100) {
        progress += Math.random() * 2;
        if (progress > 100) progress = 100;
        updateLoadingBar();
        setTimeout(simulateLoading, 100);
    }
}

// Update loading bar and status
function updateLoadingBar() {
    loadingBar.style.width = `${progress}%`;
    
    if (progress < 30) {
        statusText.textContent = 'Loading resources...';
    } else if (progress < 60) {
        statusText.textContent = 'Initializing scripts...';
    } else if (progress < 90) {
        statusText.textContent = 'Connecting to server...';
    } else {
        statusText.textContent = 'Almost ready...';
    }

    if (progress === 100) {
        setTimeout(() => {
            statusText.textContent = 'Welcome to the server!';
        }, 500);
    }
}

// Update tips
function updateTip() {
    currentTip = (currentTip + 1) % tips.length;
    tipsElement.textContent = tips[currentTip];
    tipsElement.style.opacity = '0';
    setTimeout(() => {
        tipsElement.style.opacity = '0.8';
    }, 200);
}

// Initialize background music
function initializeMusic() {
    music.volume = 0.3;
    music.play().catch(() => {
        // Auto-play blocked by browser
        toggleMusicBtn.innerHTML = '<i class="fas fa-volume-mute"></i>';
    });
}

// Handle loading events from FiveM
window.addEventListener('message', (e) => {
    if (e.data.eventName === 'loadProgress') {
        progress = e.data.loadFraction * 100;
        updateLoadingBar();
    }
});

// Particle effect background
const canvas = document.createElement('canvas');
canvas.style.position = 'fixed';
canvas.style.top = '0';
canvas.style.left = '0';
canvas.style.zIndex = '-1';
document.body.appendChild(canvas);

const ctx = canvas.getContext('2d');
let particles = [];

function resizeCanvas() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
}

window.addEventListener('resize', resizeCanvas);
resizeCanvas();

class Particle {
    constructor() {
        this.reset();
    }

    reset() {
        this.x = Math.random() * canvas.width;
        this.y = Math.random() * canvas.height;
        this.size = Math.random() * 2;
        this.speedX = (Math.random() - 0.5) * 0.5;
        this.speedY = (Math.random() - 0.5) * 0.5;
        this.opacity = Math.random() * 0.5;
    }

    update() {
        this.x += this.speedX;
        this.y += this.speedY;

        if (this.x < 0 || this.x > canvas.width || this.y < 0 || this.y > canvas.height) {
            this.reset();
        }
    }

    draw() {
        ctx.fillStyle = `rgba(255, 255, 255, ${this.opacity})`;
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
        ctx.fill();
    }
}

// Create particles
for (let i = 0; i < 100; i++) {
    particles.push(new Particle());
}

function animate() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    particles.forEach(particle => {
        particle.update();
        particle.draw();
    });

    requestAnimationFrame(animate);
}

animate();

// Logo animation handling
const logoVariations = ['main', 'neon', 'glitch', 'three-d', 'interactive'];
let currentLogoIndex = 0;

function cycleLogo() {
    const mainLogo = document.querySelector('.logo-text');
    
    // Remove all classes
    logoVariations.forEach(variation => {
        mainLogo.classList.remove(variation);
    });
    
    // Add next variation
    mainLogo.classList.add(logoVariations[currentLogoIndex]);
    
    // Update index
    currentLogoIndex = (currentLogoIndex + 1) % logoVariations.length;
}

// Cycle logo every 3 seconds
setInterval(cycleLogo, 3000);

// Add click handler for interactive logo
document.querySelector('.logo-text').addEventListener('click', () => {
    const audio = new Audio('music/click.mp3');
    audio.volume = 0.2;
    audio.play();
    cycleLogo();
});
