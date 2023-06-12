console.log("Content script loaded");

// Create a toolbar element
var toolbarElement = document.createElement('div');
// Create a text container element
var textContainer = document.createElement('div');

// Set toolbar styles
toolbarElement.style.backgroundColor = '#f0f0f0';
toolbarElement.style.color = '#333';
toolbarElement.style.position = 'fixed';
toolbarElement.style.bottom = '0';
toolbarElement.style.width = '100%';
toolbarElement.style.padding = '10px 20px'; // Reduced padding
toolbarElement.style.fontSize = '18px';
toolbarElement.style.borderTop = '1px solid #ccc';
toolbarElement.style.zIndex = '1000000';
toolbarElement.style.fontFamily = "'Roboto', sans-serif";
toolbarElement.style.boxShadow = '0px 0px 10px rgba(0, 0, 0, 0.5)';
toolbarElement.style.textAlign = 'center'; // Center align text
toolbarElement.style.maxHeight = '60px'; // Set a maximum height

// Set text container styles
textContainer.style.textAlign = 'center'; // Center align text
textContainer.style.paddingBottom = '3px'; // Reduced padding to the bottom of the text
textContainer.style.lineHeight = '1.5'; // Added line height

// Append text container to toolbar
toolbarElement.appendChild(textContainer);

// Append toolbar to body
document.body.appendChild(toolbarElement);
// Listen for Ctrl + Q key press
document.addEventListener("keydown", function(event) {
  if (event.ctrlKey && event.key === 'q') {
    chrome.runtime.sendMessage({action: "get_chat_gpt_response"}, function(response) {
      if (chrome.runtime.lastError) {
        console.error(chrome.runtime.lastError);
        event.preventDefault();  // Add this line
      } else if (response && response.answer) {
        toolbarElement.innerText = response.answer;
      }
    });
    event.preventDefault();
  }
}, true);
