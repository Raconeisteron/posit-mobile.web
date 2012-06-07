#!/bin/bash
URL=http://turing.cs.trincoll.edu/~pgautam/positweb2
#echo "Login Test"
#curl "$URL/api/login?password=logmein&imei=354957032494240"
#echo 
#echo "Registration Test"
#curl "$URL/api/registerUser?email=prasannagautam@gmail.com&firstname=Prasanna&lastname=Gautam&password1=testpassword&password2=testpassword";
#echo "Sync Test"
#curl "$URL/api/recordSync?authKey=5yv7zVCjMkqhJUTj&imei=354957032494240"
#echo
echo "createProject test"
curl -d "name=waka%20wakadescription=test" "$URL/api/createProject?authKey=VHa2Zx6fIXZTicby"
