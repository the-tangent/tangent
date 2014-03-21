window.onloads = [];
window.onload = function() {
  for (i = 0; i < window.onloads.length; i++) {
    window.onloads[i]();
  }
}
