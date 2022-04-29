const containerDiv = document.getElementById("vizContainer");
const url = "http://public.tableau.com/views/RegionalSampleWorkbook/Storms";
const options = {
    hideTabs: true,
};

function initViz(){
    let viz = new tableau.Viz(containerDiv, url, options);

}

document.addEventListener("DOMContentLoaded", initViz);