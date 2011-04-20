/* Author: Eric Koslow

*/

$(function() {
  var t;
  //Functions
  function add_leading_zero(n) {
    if (n.toString().length < 2) {
      return '0'+n;
    } else {
      return n;
    }
  }
  function decrement_times() {
    $(".timeleft").each(function(index) {
      var time = $(this);
      var i = parseInt(time.text());
      if(i >= 0) {
        time.siblings(".time").html(add_leading_zero(Math.floor(i/60))+':'+add_leading_zero(i%60));
        time.text(parseInt(time.text())-1);
      }
    });
    setTimeout(decrement_times, 1000);
  }


  // Main Program
  decrement_times();
  if (window.File && window.FileReader && window.FileList && window.Blob) {
    // Great success! All the File APIs are supported.
    $("input#files").change(function(evt) {
      var self = this;
      var files = evt.target.files; // FileList object

      // Loop through the FileList and render audio files as audio tags.
      for (var i = 0, f; f = files[i]; i++) {

        // Only process image files.
        if (!f.type.match('audio.*')) {
          continue;
        }

        var reader = new FileReader();

        // Closure to capture the file information.
        reader.onload = (function(theFile) {
          return function(e) {
            // Render audio tag.
            var span = document.createElement('li');
            span.innerHTML = ['<audio src="', e.target.result,
          '" controls="controls">Your Browser does not support the audio tag',
          '</audio>'].join('');
        $(self).siblings("#list").append(span);
          };
        })(f);

        // Read in the audio file as a data URL.
        reader.readAsDataURL(f);
      }
    });
  } else {
    alert('The File APIs are not fully supported in this browser.');
  }
});





















