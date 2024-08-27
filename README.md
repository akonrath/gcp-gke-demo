## Summary
This repository creates a publicly exposed web application in GCP, a MongoDB server, and a publicly accessible  storage bucket.

## Application
The application used in this repository was obtained from the following repository and modified to copy a text file into the image:
https://github.com/jeffthorne/tasky


## Usage
```
make gcloud-login
make build
make push
make apply
```

## Known Issues
The initial apply will fail because the image doesn't exist in the registry. Running 'make push' and then re-applying should succeed.
