// Auxilliary functions for the Visual Fourier page
function get_center_of_mass(xvals, yvals) {
    const arrAvg = arr => arr.reduce((a,b) => a + b, 0) / arr.length;
    xmean = 2*arrAvg(xvals);
    ymean = 2*arrAvg(yvals);
    return [xmean, ymean]
}