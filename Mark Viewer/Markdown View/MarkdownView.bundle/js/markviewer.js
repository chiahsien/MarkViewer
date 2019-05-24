function changeCSS(fileName) {
    document.querySelectorAll("link[href]")[1].href = "css/syntax highlight/" + fileName + ".css";
}
