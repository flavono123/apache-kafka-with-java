// parse the page: https://docs.confluent.io/platform/current/connect/references/restapi.html#
// Function to parse the API table
function parseAPITable() {
  const apiDetails = [];
  // Select all 'dl' elements with class 'http get' or 'http put'
  const apiElements = document.querySelectorAll('dl.http');

  apiElements.forEach(apiElement => {
    // Extracting method
    const method = apiElement.querySelector('code.sig-name.descname span.pre').textContent.trim();

    // Extracting path by traversing through each child node of 'dt', starting from the second child
    const dtElements = apiElement.querySelector('dt').childNodes;
    let path = '';
    for (let i = 2; i < dtElements.length - 1; i++) { // Starting from second child and ignoring the last one
      if (dtElements[i].textContent) {
        path += dtElements[i].textContent.trim();
      }
    }

    // Extracting description
    const description = apiElement.querySelector('dd p').textContent.trim();

    // Construct the API details object
    const apiDetail = {
      method,
      path,
      description
    };

    // Add to the array
    apiDetails.push(apiDetail);
  });

  return apiDetails;
}

// Run the function and log the result
console.log(parseAPITable());
