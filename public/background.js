// The function to fetch the answer
function fetchAnswer() {
    return new Promise((resolve, reject) => {
      console.log('Fetching answer...');
      
      // Capture the current visible tab
      chrome.tabs.captureVisibleTab(null, {}, function (image) {
        const body = JSON.stringify({ image: image });
        
        // Send the screenshot to the server
        fetch('http://35.199.27.114:5000/get_answer', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: body
        })
        .then(response => response.json())
        .then(data => {
          resolve(data.answer);
        })
        .catch((error) => {
          console.error('Error:', error);
          reject(error);
        });
      });
    });
  }
  
  // Listen for messages from content.js
  chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.action === "get_chat_gpt_response") {
      fetchAnswer().then(response => {
        console.log('Sending response:', response);
        sendResponse({ answer: response });
      }).catch((error) => {
        console.error('Error:', error);
        sendResponse({ error: error.message });
      });
  
      return true;  // Indicates that the response will be sent asynchronously
    }
  });
  