[![Build Status](https://travis-ci.org/ljw980105/jingweili.me-backend.svg?branch=master)](https://travis-ci.org/ljw980105/jingweili.me-backend)

# [jingweili.me](https://jingweili.me) Backend

Backend server code for the frontend website [jingweili.me](https://jingweili.me), whose repository is [here](https://github.com/ljw980105/jingweili.me).

This project utilizes [Vapor](https://github.com/vapor/vapor) 3, a library for server-side Swift.

## Feature Flags
To run the vapor project you must supply a json file named `FeatureFlags.json` to the root directory to configure the server:

```json
{
    "unrestrictedCORS": Bool
}
```

### Running the project 
```bash
swift build
.build/debug/Run &> output.log &
disown %1
```

### Foundation APIs that does not work on Linux
* `URL`
    * `func resourceValues(forKeys keys: Set<URLResourceKey>) throws -> URLResourceValues`
* `FileManager`
    * `FileManager.DirectoryEnumerationOptions`
