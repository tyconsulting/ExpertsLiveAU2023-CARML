targetScope = 'subscription'

// ========== //
// Test Cases //
// ========== //

var namePrefix = 'asb'

// TEST 1 - Blob
module blob 'blob/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-blob-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 2 - File
module file 'file/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-file-test'
  params: {
    namePrefix: namePrefix
  }
}

// TEST 3 - Queue
module queue 'queue/main.test.bicep' = {
  name: '${uniqueString(deployment().name)}-queue-test'
  params: {
    namePrefix: namePrefix
  }
}
