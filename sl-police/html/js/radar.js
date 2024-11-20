$(document).ready(function() {
    window.addEventListener('message', function(event) {
        const data = event.data;
        
        if (data.action === "updateRadar") {
            updateRadarDisplay(data.data);
        }
    });
});

function updateRadarDisplay(data) {
    $('#front-speed').text(data.frontSpeed.padStart(3, '0'));
    $('#front-plate').text(data.frontPlate);
    $('#rear-speed').text(data.rearSpeed.padStart(3, '0'));
    $('#rear-plate').text(data.rearPlate);
} 