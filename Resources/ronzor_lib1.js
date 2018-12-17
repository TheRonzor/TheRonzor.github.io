function make_standard_axes(id, height, width, margin, xMin, xMax, yMin, yMax, tMin, tMax, fillColor) {
    // Initialize svg first in calling script.  svg should be updated by reference?
    // Return X,Y,T linear scales.
    // d3 should be loaded first in HTML.
    var w = width - margin.right - margin.left,
        h = height - margin.top - margin.bottom,
        X = new d3.scaleLinear()
            .domain([xMin, xMax])
            .range([0, w]),
        Y = new d3.scaleLinear()
            .domain([yMin, yMax])
            .range([h, 0]),
        T = new d3.scaleLinear()
            .domain([tMin, tMax])
            .range([tMin, tMax]),
        xAxis = new d3.axisBottom(X).ticks(5),
        yAxis = new d3.axisLeft(Y).ticks(5);
        svg = new d3.select(id)
            .append('svg')
            .attr('width', w + margin.left + margin.right)
            .attr('height', h + margin.top + margin.bottom)
            .append('g')
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    
    svg.append('rect')
        .attr("x", 0)
        .attr("y", 0)
        .attr("height", h + margin.top + margin.bottom)
        .attr("width", w + margin.left + margin.right)
        .style("fill", fillColor)
        .attr("transform", "translate(" + -margin.left + "," + -margin.top + ")");
    
    svg.append("g")
        .attr("class", "axis")
        .attr("transform", "translate(0," + h + ")")
        .call(xAxis);

    svg.append("g")
        .attr("class", "axis")
        .call(yAxis);
    
    return [svg, X, Y, T];
}

function make_svg_path_from_data(xt, yt, X, Y) {
    // Function expects xt and yt in terms of data.
    // X and Y are linearScale objects mapping to the SVG coordinates
    // Returns a string containing the SVG path.
    var path_d = 'M' + X(xt[0]) + ',' +Y(yt[0]);
    for (var i = 1; i < xt.length; i++) {
        path_d = path_d + ' L' + X(xt[i]) + ',' + Y(yt[i]);
    }
    return (path_d)
}

